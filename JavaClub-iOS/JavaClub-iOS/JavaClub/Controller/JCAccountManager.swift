//
//  JCAccountManager.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftyRSA
import Defaults

enum JCError: Error {
    case pubKeyReqFailure
    case badRequest
    case noData
    case parseErr
    case encryptKeyErr
    case notLogin
    case inputErr
}


class JCAccountManager {
    static let shared = JCAccountManager()
    
    private init() {}
}


// MARK: Shared Methods
extension JCAccountManager {
    
    /**
     *  Login to one's JavaClub account.
     *
     *  - Parameters:
     *      - info: One's login info containing username and password. Username can be one's user ID or email address.
     *      - completion: A block to check if it's logged in.
     */
    func login(info: JCLoginInfo, _ completion: @escaping (Result<Bool, JCError>) -> Void) {
        requestPubKey { [weak self] result in
            guard let key = try? result.get() else {
                completion(.failure(.pubKeyReqFailure))
                return
            }
            
            do {
                // Encrypt Password
                let encryptedStr = try self?.encrypt(info.password, with: key)
                let parameters = [
                    "id": info.username,
                    "password": encryptedStr,
                    "remember-me": "false"
                ]
                
                // Request Login
                AF.request(
                    "http://api.cduestc.club/api/auth/login",
                    method: .post,
                    parameters: parameters
                ).response { response in
                    guard let data = response.data else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        if
                            let status = (try JSON(data: data))["status"].int,
                            status == 200
                        {
                            let resultJson = (try JSON(data: data))["data"]
                            completion(.success(resultJson.boolValue))
                        } else {
                            completion(.failure(.badRequest))
                        }
                    } catch {
                        print("ERR: (Load JSON) \(error.localizedDescription)")
                        completion(.failure(.parseErr))
                    }
                }
            } catch {
                print("ERR: (Encrypt) \(error.localizedDescription)")
                completion(.failure(.encryptKeyErr))
            }
        }
    }
    
    /**
     *  Logout one's JavaClub account.
     *
     *  By default, JavaClub app will logout one's account by the time they terminate the app.
     */
    func logout(clean: Bool) {
        AF.request("http://api.cduestc.club/api/auth/logout").response { response in
            guard let data = response.data else { return }
            
            do {
                if
                    let status = (try JSON(data: data))["status"].int,
                    status == 200
                {
                    if clean {
                        Defaults[.avatarURL] = nil
                        Defaults[.avatarLocal] = nil
                        Defaults[.bannerURL] = nil
                        Defaults[.bannerLocal] = nil
                        Defaults[.loginInfo] = nil
                        Defaults[.sessionURL] = nil
                        Defaults[.user] = nil
                        Defaults[.jwInfo] = nil
                        Defaults[.sessionExpired] = false
                        Defaults[.enrollment] = nil
                        JCBindingVerify.shared.verified = false
                    }
                    print("DEBUG: Logged Out Successfully.")
                }
            } catch {
                print("ERR: \(error.localizedDescription)")
            }
        }
    }
    
    /**
     *  Get one's info in forum.
     *
     *  - Parameters:
     *      - completion: A block of what you wanna do with the user's info.
     */
    func getInfo(_ completion: @escaping (Result<JCUser, JCError>) -> Void) {
        AF.request("http://api.cduestc.club/api/auth/info").response { response in
            guard let data = response.data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                if
                    let status = (try JSON(data: data))["status"].int,
                    status == 200
                {
                    let json = (try JSON(data: data))["data"]
                    let user = JCUser(
                        username: json["username"].stringValue,
                        email: json["email"].stringValue,
                        signature: json["signature"].stringValue.isEmpty
                            ? nil
                            : json["signature"].stringValue,
                        studentID: json["bindId"].stringValue.isEmpty
                            ? nil
                            : json["bindId"].stringValue
                    )
                    
                    completion(.success(user))
                } else {
                    completion(.failure(.badRequest))
                }
            } catch {
                completion(.failure(.parseErr))
                print("ERR: \(error.localizedDescription)")
            }
        }
    }
    
    /**
     *  Refresh an user's avatar and banner.
     *
     *  - Parameters:
     *      - completion: A block that tells the process is complete.
     */
    func refreshUserMedia() {
        if let avatarURL = Defaults[.avatarURL] {
            JCImageManager.shared.loadImage(url: avatarURL) { img in
                if let img = img {
                    Defaults[.avatarLocal] = JCImageManager.shared.saveToDisk("avatar", img: img)
                }
            }
        }
        
        if let bannerURL = Defaults[.bannerURL] {
            JCImageManager.shared.loadImage(url: bannerURL) { img in
                if let img = img {
                    Defaults[.bannerLocal] = JCImageManager.shared.saveToDisk("banner", img: img)
                }
            }
        }
    }
    
    /**
     *  Refresh an user's all session data.
     *
     *  - Parameters:
     *      - completion: A block that tells the process is complete.
     */
    func refreshCompletely() {
        // Refresh User Media
        if Defaults[.sessionURL] == nil {
            JCAccountManager.shared.getSession { urlStr, avatar, banner in
                Defaults[.sessionURL] = urlStr
                
                if let avatar = avatar {
                    Defaults[.avatarURL] = avatar
                }
                
                if let banner = banner {
                    Defaults[.bannerURL] = banner
                }
                
                // Save Avatar To Local If Possible
                if let avatar = avatar {
                    JCImageManager.shared.loadImage(url: avatar) { img in
                        if let img = img {
                            Defaults[.avatarLocal] = JCImageManager.shared.saveToDisk("avatar", img: img)
                        }
                    }
                }
                
                // Save Banner To Local If Possible
                if let banner = banner {
                    JCImageManager.shared.loadImage(url: banner) { img in
                        if let img = img {
                            Defaults[.bannerLocal] = JCImageManager.shared.saveToDisk("banner", img: img)
                        }
                    }
                }
            }
        }
    }
    
    /**
     *  Bind your student ID with your JavaClub account.
     *
     *  Every user should bind thier student ID with thier JavaClub account otherwise they cannot use any service from JavaClub app.
     *
     *  - Parameters:
     *      - id: One's student ID.
     *      - completion: A block of what you wanna do with the result of the binding process.
     */
    func bindStudentID(info: KCLoginInfo, _ completion: @escaping (Result<Bool, JCError>) -> Void) {
        requestPubKey { [weak self] result in
            guard let key = try? result.get() else {
                completion(.failure(.pubKeyReqFailure))
                return
            }
            
            do {
                // Encrypt Password
                let encryptedStr = try self?.encrypt(info.password, with: key)
                let parameters = [
                    "id": info.id,
                    "password": encryptedStr
                ]
                
                // Request To Bind StudentID
                AF.request(
                    "http://api.cduestc.club/api/auth/bind-id",
                    method: .post,
                    parameters: parameters
                ).response { response in
                    guard let data = response.data else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        if
                            let status = (try JSON(data: data))["status"].int,
                            status == 200
                        {
                            let json = (try JSON(data: data))["data"]
                            if json.boolValue {
                                Defaults[.jwInfo] = info
                                completion(.success(json.boolValue))
                                print("DEBUG: Binding Successful.")
                            } else {
                                completion(.failure(.inputErr))
                                print("DEBUG: Binding Failed.")
                            }
                        } else {
                            completion(.failure(.badRequest))
                        }
                    } catch {
                        completion(.failure(.parseErr))
                        print("ERR: \(error.localizedDescription)")
                    }
                }
            } catch {
                completion(.failure(.encryptKeyErr))
                print("ERR: (Encrypt) \(error.localizedDescription)")
            }
        }
    }
    
    /**
     *  Get one's enrollment info of CDUESTC.
     *
     *  - Parameters:
     *      - completion: A block of what you wanna do with the result of one's enrollment info.
     */
    func getEnrollmentInfo(_ completion: @escaping (Result<KAEnrollment, JCError>) -> Void) {
        guard let loginInfo = Defaults[.jwInfo] else {
            completion(.failure(.notLogin))
            return
        }
        
        requestPubKey { [weak self] result in
            guard let key = try? result.get() else {
                completion(.failure(.pubKeyReqFailure))
                return
            }
            
            do {
                let encryptedStr = try self?.encrypt(loginInfo.password, with: key) ?? ""
                let parameters: [String: String] = ["password": encryptedStr]
                
                AF.request(
                    "http://api.cduestc.club/api/kc/info",
                    method: .post,
                    parameters: parameters
                ).response { response in
                    guard let data = response.data else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        if
                            let status = (try JSON(data: data))["status"].int,
                            status == 200
                        {
                            let json = (try JSON(data: data))["data"]
                            let enrollment = KAEnrollment(
                                campus: json["所属校区"].stringValue,
                                degree: json["学历层次"].stringValue,
                                system: json["学制"].stringValue,
                                dateEnrolled: json["入校时间"].stringValue,
                                dateGraduation: json["毕业时间"].stringValue,
                                department: json["院系"].stringValue,
                                subject: json["专业"].stringValue,
                                grade: json["年级"].stringValue,
                                direction: json["方向"].stringValue,
                                _class: json["所属班级"].stringValue,
                                enrollmentForm: json["学习形式"].stringValue,
                                enrollmentStatus: json["学籍状态"].stringValue,
                                name: json["姓名"].stringValue,
                                engName: json["英文名"].stringValue,
                                gender: json["性别"].stringValue,
                                studentID: json["学号"].stringValue
                            )
                            completion(.success(enrollment))
                        } else {
                            completion(.failure(.badRequest))
                        }
                    } catch {
                        completion(.failure(.parseErr))
                        print("ERR: \(error.localizedDescription)")
                    }
                }
            } catch {
                completion(.failure(.encryptKeyErr))
                print(error.localizedDescription)
            }
        }
    }
    
    func getScore(_ completion: @escaping (Result<String, JCError>) -> Void) {
        guard let loginInfo = Defaults[.jwInfo] else {
            completion(.failure(.notLogin))
            return
        }
        
        requestPubKey { [weak self] result in
            guard let key = try? result.get() else {
                completion(.failure(.pubKeyReqFailure))
                return
            }
            
            do {
                let encryptedStr = try self?.encrypt(loginInfo.password, with: key) ?? ""
                let parameters: [String: String] = ["password": encryptedStr]
                
                AF.request(
                    "http://api.cduestc.club/api/kc/score",
                    method: .post,
                    parameters: parameters
                ).response { response in
                    guard let data = response.data else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        if
                            let status = (try JSON(data: data))["status"].int,
                            status == 200
                        {
                            let json = (try JSON(data: data))["data"]
                            completion(.success(json.stringValue))
                        } else {
                            completion(.failure(.badRequest))
                        }
                    } catch {
                        completion(.failure(.parseErr))
                        print("ERR: \(error.localizedDescription)")
                    }
                }
            } catch {
                completion(.failure(.encryptKeyErr))
                print(error.localizedDescription)
            }
        }
    }
}


// MARK: Private Methods -
extension JCAccountManager {
    
    private func encrypt(_ content: String, with key: String) throws -> String? {
        do {
            let pubKey = try PublicKey(pemEncoded: key)
            let clear = try ClearMessage(string: content, using: .utf8)
            let encrypted = try clear.encrypted(with: pubKey, padding: .PKCS1)
            
            return encrypted.base64String
        } catch {
            throw JCError.encryptKeyErr
        }
    }
    
    private func requestPubKey(_ completion: @escaping (Result<String, JCError>) -> Void) {
        AF.request("http://api.cduestc.club/api/auth/public-key").response { response in
            guard let data = response.data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let jsonStr = (try JSON(data: data))["data"].stringValue
                completion(.success(jsonStr))
            } catch {
                completion(.failure(.parseErr))
                print("ERR: \(error.localizedDescription)")
            }
        }
    }
    
    private func getSession(_ completion: @escaping (URL?, URL?, URL?) -> Void) {
        AF.request("http://api.cduestc.club/api/auth/forum").response { response in
            guard let data = response.data else {
                completion(nil, nil, nil)
                return
            }
            
            do {
                if
                    let status = (try JSON(data: data))["status"].int,
                    status == 200
                {
                    let json = (try JSON(data: data))["data"]
                    
                    let urlStr = json["index"].stringValue
                    let avatar = json["urlAvatar"].stringValue
                    let banner = json["urlBackground"].stringValue
                    
                    let url = URL(string: urlStr)
                    let avatarURL = URL(string: avatar)
                    let bannerURL = URL(string: banner)
                    
                    completion(url, avatarURL, bannerURL)
                } else {
                    completion(nil, nil, nil)
                }
            } catch {
                completion(nil, nil, nil)
                print("ERR: \(error.localizedDescription)")
            }
        }
    }
}

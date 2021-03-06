//
//  JCAccountManager.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import Foundation
import Alamofire
import SwiftyJSON
import Defaults
import SwiftyRSA
import WebKit
import Kingfisher

enum JCError: Error {
    case pubKeyReqFailure
    case badRequest
    case noData
    case parseErr
    case encryptKeyErr
    case notLoginJC
    case notLoginJW
    case notLoginBY
    case wrongPassword
    case unknown
    case castErr
    case illegalParameter
    case imgRetrieveFailed
    case selfGotReleased
    case timeout
}


class JCAccountManager {
    static let shared = JCAccountManager()
    
    let javaClubURL = URL(string: "https://study.cduestc.club/index.php")!
    
    private init() {}
}


// MARK: Shared Methods -
extension JCAccountManager {
    
    /**
     *  Login to one's JavaClub account.
     *
     *  - Parameters:
     *      - info: One's login info containing username and password. Username can be one's user ID or email address.
     *      - completion: A block to check if it's logged in.
     */
    func login(info: JCLoginInfo, _ completion: @escaping (Result<Bool, JCError>) -> Void) {
        requestPubKey(retry: 3) { [weak self] result in
            var key: String?
            
            switch result {
            case .success(let _key):
                key = _key
                
            case .failure(let error):
                print("DEBUG: Request Public Key Failed With Error: \(String(describing: error))")
            }
            
            guard let key = key else {
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
                    "https://api.cduestc.club/api/auth/login",
                    method: .post,
                    parameters: parameters
                ).response { response in
                    guard let data = response.data else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        let status = (try JSON(data: data))["status"].intValue
                        
                        if status == 200 {
                            let success = (try JSON(data: data))["data"].boolValue
                            completion(.success(success))
                        } else {
                            completion(.failure(.badRequest))
                            print("DEBUG: Login JC Failed With Code: \(status)")
                        }
                    } catch {
                        print("DEBUG: (Load JSON) \(error.localizedDescription)")
                        completion(.failure(.parseErr))
                    }
                }
            } catch {
                print("DEBUG: (Encrypt) \(error.localizedDescription)")
                completion(.failure(.encryptKeyErr))
            }
        }
    }
    
    /**
     *  Logout one's JavaClub account.
     *
     *  By default, JavaClub app will logout one's account by the time they terminate the app.
     */
    func logout(clean: Bool = false) {
        AF.request("https://api.cduestc.club/api/auth/logout").response { _ in }
        
        JCLoginState.shared.logout()
        
        if clean {
            ImageCache.default.clearDiskCache(completion: nil)
            
            // JC
            Defaults[.jcUser] = nil
            Defaults[.jcLoginInfo] = nil
            Defaults[.sessionURL] = nil
            Defaults[.avatarURL] = nil
            Defaults[.bannerURL] = nil
            
            // JW
            Defaults[.jwLoginInfo] = nil
            Defaults[.firstLogin] = true
            Defaults[.enrollment] = nil
            Defaults[.classTableTerm] = 1
            Defaults[.classTableJsonData] = nil
            
            // BY
            Defaults[.byLoginInfo] = nil
            Defaults[.byAccount] = nil
            
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
            
            WKWebsiteDataStore
                .default()
                .removeData(
                    ofTypes: [WKWebsiteDataTypeCookies],
                    modifiedSince: Date.distantPast,
                    completionHandler: {}
                )
        }
    }
    
    /**
     *  Get one's info in forum.
     *
     *  - Parameters:
     *      - completion: A block of what you wanna do with the user's info.
     */
    func getInfo(_ completion: @escaping (Result<JCUser, JCError>) -> Void) {
        AF.request("https://api.cduestc.club/api/auth/info").response { response in
            guard let data = response.data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let status = (try JSON(data: data))["status"].intValue
                
                if status == 200 {
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
                } else if status == 403 {
                    completion(.failure(.notLoginJC))
                } else {
                    completion(.failure(.badRequest))
                    print("DEBUG: Fetch User Info Failed With Code: \(status)")
                }
            } catch {
                completion(.failure(.parseErr))
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
    
    /**
     *  Refresh an user's all session data.
     *
     *  - Parameters:
     *      - completion: A block that tells the process is complete.
     */
    func getUserMedia(_ completion: ((Bool) -> Void)? = nil) {
        // Refresh User Media
        JCAccountManager.shared.getSession { urlStr, avatar, banner in
            if Defaults[.sessionURL] == nil, let urlStr = urlStr {
                Defaults[.sessionURL] = urlStr
                completion?(true)
            } else {
                completion?(false)
            }
            
            if Defaults[.avatarURL] == nil, let avatar = avatar {
                Defaults[.avatarURL] = avatar
            }
            
            if Defaults[.bannerURL] == nil, let banner = banner {
                Defaults[.bannerURL] = banner
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
    func loginJW(info: KALoginInfo, bind: Bool = false, _ completion: @escaping (Result<Bool, JCError>) -> Void) {
        requestPubKey(retry: 3) { [weak self] result in
            guard let key = try? result.get() else {
                completion(.failure(.pubKeyReqFailure))
                return
            }
            
            guard let weakSelf = self else {
                completion(.failure(.selfGotReleased))
                return
            }
            
            do {
                // Encrypt Password
                let encryptedStr = try weakSelf.encrypt(info.password, with: key) ?? ""
                
                // Request To Bind StudentID
                AF.request(
                    bind
                    ? "https://api.cduestc.club/api/auth/bind-id"
                    : "https://api.cduestc.club/api/kc/login",
                    method: .post,
                    parameters: bind
                    ? [
                        "id": info.id,
                        "password": encryptedStr
                    ]
                    : [
                        "password": encryptedStr
                    ],
                    requestModifier: { $0.timeoutInterval = 10 }
                ).response { response in
                    guard let data = response.data else {
                        completion(.failure(.noData))
                        return
                    }
                    
                    do {
                        let status = (try JSON(data: data))["status"].intValue
                        
                        if status == 200 {
                            let success = (try JSON(data: data))["data"].boolValue
                            completion(.success(success))
                        } else if status == 403 {
                            completion(.failure(.notLoginJC))
                        } else if status == 401 {
                            completion(.failure(.wrongPassword))
                        } else {
                            completion(.failure(.badRequest))
                            print("DEBUG: Login JW Failed With Code: \(status)")
                        }
                    } catch {
                        completion(.failure(.parseErr))
                        print("DEBUG: \(error.localizedDescription)")
                    }
                }
            } catch {
                completion(.failure(.encryptKeyErr))
                print("DEBUG: (Encrypt) \(error.localizedDescription)")
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
        guard Defaults[.jwLoginInfo] != nil else {
            completion(.failure(.notLoginJW))
            return
        }
        
        AF.request(
            "https://api.cduestc.club/api/kc/info",
            method: .post,
            requestModifier: { $0.timeoutInterval = 10 }
        ).response { response in
            guard let data = response.data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let status = (try JSON(data: data))["status"].intValue
                
                if status == 200 {
                    let json = (try JSON(data: data))["data"]
                    let enrollment = KAEnrollment(
                        campus: json["????????????"].stringValue,
                        degree: json["????????????"].stringValue,
                        system: json["??????"].stringValue,
                        dateEnrolled: json["????????????"].stringValue,
                        dateGraduation: json["????????????"].stringValue,
                        department: json["??????"].stringValue,
                        subject: json["??????"].stringValue,
                        grade: json["??????"].stringValue,
                        direction: json["??????"].stringValue,
                        _class: json["????????????"].stringValue,
                        enrollmentForm: json["????????????"].stringValue,
                        enrollmentStatus: json["????????????"].stringValue,
                        name: json["??????"].stringValue,
                        engName: json["?????????"].stringValue,
                        gender: json["??????"].stringValue,
                        studentID: json["??????"].stringValue
                    )
                    completion(.success(enrollment))
                } else if status == 401 {
                    completion(.failure(.notLoginJW))
                } else if status == 403 {
                    completion(.failure(.notLoginJC))
                } else {
                    completion(.failure(.badRequest))
                    print("DEBUG: Fetch Enrollment Info Failed With Code: \(status)")
                }
            } catch {
                completion(.failure(.parseErr))
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
    
    /**
     *  Get one's scores.
     *
     *  - Parameters:
     *      - completion: A block of what you wanna do with the result of one's scores.
     */
    func getScore(_ completion: @escaping (Result<[KAScore], JCError>) -> Void) {
        guard Defaults[.jwLoginInfo] != nil else {
            completion(.failure(.notLoginJW))
            return
        }
        
        AF.request(
            "https://api.cduestc.club/api/kc/score",
            method: .post,
            requestModifier: { $0.timeoutInterval = 10 }
        ).response { response in
            guard let data = response.data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let status = (try JSON(data: data))["status"].intValue
                
                if status == 200 {
                    let jsonArray = (try JSON(data: data))["data"].arrayValue
                    var result: [KAScore] = []
                    
                    jsonArray.forEach { json in
                        let score = KAScore(
                            year: json["year"].stringValue,
                            term: json["term"].intValue,
                            className: json["name"].stringValue,
                            classCode: json["code"].stringValue,
                            classIndex: json["index"].stringValue,
                            classType: json["type"].stringValue,
                            points: json["points"].doubleValue,
                            credits: json["credits"].doubleValue,
                            score: json["score_all"].doubleValue,
                            redoScore: json["redo_score_all"].doubleValue
                        )
                        
                        result.append(score)
                    }
                    
                    completion(.success(result))
                } else if status == 401 {
                    completion(.failure(.notLoginJW))
                } else if status == 403 {
                    completion(.failure(.notLoginJC))
                } else {
                    completion(.failure(.badRequest))
                    print("DEBUG: Fetch Score Failed With Code: \(status)")
                }
            } catch {
                completion(.failure(.parseErr))
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
    
    /**
     *  Get one's class table.
     *
     *  - Parameters:
     *      - completion: A block of what you wanna do with the result of one's class table.
     */
    func getClassTable(term: Int, _ completion: @escaping (Result<[KAClass], JCError>) -> Void) {
        guard JCLoginState.shared.jw, let enrollment = Defaults[.enrollment] else {
            completion(.failure(.notLoginJW))
            return
        }
        
        let degreeCheck = enrollment.degree == "??????"
        
        guard (1 ... (degreeCheck ? 8 : 6)).contains(term) else {
            completion(.failure(.illegalParameter))
            return
        }
        
        AF.request(
            "https://api.cduestc.club/api/kc/table",
            method: .post,
            parameters: ["term": "\(term)"],
            requestModifier: { $0.timeoutInterval = 10 }
        ).response { response in
            guard let data = response.data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let status = (try JSON(data: data))["status"].intValue
                
                if status == 200 {
                    if let result = ClassTableManager.shared.decode(from: data) {
                        completion(.success(result))
                    } else {
                        completion(.failure(.parseErr))
                    }
                } else if status == 401 {
                    completion(.failure(.notLoginJW))
                } else if status == 403 {
                    completion(.failure(.notLoginJC))
                } else {
                    completion(.failure(.badRequest))
                    print("DEBUG: Fetch Class Table Failed With Code: \(status)")
                }
            } catch {
                completion(.failure(.parseErr))
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
}


// MARK: Private Methods -
extension JCAccountManager {
    
    private func encrypt(_ content: String, with key: String) throws -> String? {
        let pubKey = try? PublicKey(pemEncoded: key)
        let clear = try? ClearMessage(string: content, using: .utf8)
        
        if let pubKey = pubKey, let clear = clear {
            let encrypted = try? clear.encrypted(with: pubKey, padding: .PKCS1)
            
            return encrypted?.base64String
        }
        
        return nil
    }
    
    private func requestPubKey(retry count: Int, _ completion: @escaping (Result<String, JCError>) -> Void) {
        AF.request("https://api.cduestc.club/api/auth/public-key", requestModifier: { $0.timeoutInterval = 10 }).response { [weak self] response in
            guard let data = response.data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let status = (try JSON(data: data))["status"].intValue
                let jsonStr = (try JSON(data: data))["data"].stringValue
                
                if status == 200, jsonStr != "failed" {
                    print("DEBUG: Request Public Key Succeeded.")
                    completion(.success(jsonStr))
                } else {
                    print("DEBUG: Request Public Key Failed.")
                    
                    if count != 0 {
                        self?.requestPubKey(retry: count - 1, completion)
                    } else {
                        completion(.failure(.pubKeyReqFailure))
                    }
                }
            } catch {
                completion(.failure(.parseErr))
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
    
    private func getSession(_ completion: @escaping (URL?, URL?, URL?) -> Void) {
        AF.request(
            "https://api.cduestc.club/api/auth/forum",
            requestModifier: { $0.timeoutInterval = 10 }
        ).response { response in
            guard let data = response.data else {
                print("DEBUG: Fetch User Media Failed (No Data Response).")
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
                    
                    print("DEBUG: Fetch User Media Succeeded.")
                    completion(url, avatarURL, bannerURL)
                } else {
                    print("DEBUG: Fetch User Media Failed.")
                    completion(nil, nil, nil)
                }
            } catch {
                print("DEBUG: Fetch User Media Failed With Error: \(error.localizedDescription)")
                completion(nil, nil, nil)
            }
        }
    }
}

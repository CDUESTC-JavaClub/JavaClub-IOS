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

class JCAccountManager {
    static let shared = JCAccountManager()
    
    private init() {}
}


extension JCAccountManager {
    
    /**
     *  Request public key from the server.
     *
     *  One should request the public key before one can continue to login or else.
     *
     *  - Parameters:
     *      - completion: A block of what you wanna do with the public key.
     */
    func requestPubKey(_ completion: @escaping (String) -> Void) {
        AF.request("http://api.cduestc.club/api/auth/public-key").response { response in
            guard let data = response.data else {
                completion("")
                return
            }
            
            do {
                let jsonStr = (try JSON(data: data))["data"].stringValue
                completion(jsonStr)
            } catch {
                completion("")
                print("ERR: \(error.localizedDescription)")
            }
        }
    }
    
    /**
     *  Login to one's JavaClub account.
     *
     *  - Parameters:
     *      - info: One's login info containing username and password. Username can be one's user ID or email address.
     *      - completion: A block to check if it's logged in.
     */
    func login(info: JCLoginInfo, _ completion: @escaping (Bool?) -> Void) {
        requestPubKey { key in
            
            do {
                // Encrypt Password
                let pubKey = try PublicKey(pemEncoded: key)
                let clear = try ClearMessage(string: info.password, using: .utf8)
                let encrypted = try clear.encrypted(with: pubKey, padding: .PKCS1)
                let parameters = [
                    "id": info.username,
                    "password": encrypted.base64String,
                    "remember-me": "false"
                ]
                
                // Request Login
                AF.request(
                    "http://api.cduestc.club/api/auth/login",
                    method: .post,
                    parameters: parameters
                ).response { response in
                    guard let data = response.data else { return }
                    
                    do {
                        if
                            let status = (try JSON(data: data))["status"].int,
                            status == 200
                        {
                            let resultJson = (try JSON(data: data))["data"]
                            completion(resultJson.boolValue)
                        } else {
                            completion(nil)
                        }
                    } catch {
                        print("ERR: (Load JSON) \(error.localizedDescription)")
                        completion(nil)
                    }
                }
            } catch {
                print("ERR: (Encrypt) \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    /**
     *  Get one's info in forum.
     *
     *  - Parameters:
     *      - completion: A block of what you wanna do with the user's info.
     */
    func getInfo(_ completion: @escaping (JCUser?) -> Void) {
        AF.request("http://api.cduestc.club/api/auth/info").response { response in
            guard let data = response.data else {
                completion(nil)
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
                    
                    completion(user)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
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
    func bindStudentID(info: JCLoginInfo, _ completion: @escaping (Bool) -> Void) {
        requestPubKey { key in
            
            do {
                // Encrypt Password
                let pubKey = try PublicKey(pemEncoded: key)
                let clear = try ClearMessage(string: info.password, using: .utf8)
                let encrypted = try clear.encrypted(with: pubKey, padding: .PKCS1)
                let parameters = [
                    "id": info.username,
                    "password": encrypted.base64String
                ]
                
                // Request To Bind StudentID
                AF.request(
                    "http://api.cduestc.club/api/auth/bind-id",
                    method: .post,
                    parameters: parameters
                ).response { response in
                    guard let data = response.data else { return }
                    
                    do {
                        if
                            let status = (try JSON(data: data))["status"].int,
                            status == 200
                        {
                            let json = (try JSON(data: data))["data"]
                            completion(json["data"].boolValue)
                            print("DEBUG: Binding \(json["data"].boolValue)")
                        }
                    } catch {
                        completion(false)
                        print("ERR: \(error.localizedDescription)")
                    }
                }
            } catch {
                completion(false)
                print("ERR: (Encrypt) \(error.localizedDescription)")
            }
        }
    }
    
    /**
     *  Logout one's JavaClub account.
     *
     *  By default, JavaClub app will logout one's account by the time they terminate the app.
     */
    func logout() {
        AF.request("http://api.cduestc.club/api/auth/logout").response { response in
            guard let data = response.data else { return }
            
            do {
                if
                    let status = (try JSON(data: data))["status"].int,
                    status == 200
                {
                    Defaults[.avatarURL] = nil
                    Defaults[.avatarLocal] = nil
                    Defaults[.bannerURL] = nil
                    Defaults[.bannerLocal] = nil
                    Defaults[.loginInfo] = nil
                    Defaults[.sessionURL] = nil
                    Defaults[.user] = nil
                    Defaults[.sessionExpired] = false
                    print("DEBUG: Logged Out Successfully.")
                }
            } catch {
                print("ERR: \(error.localizedDescription)")
            }
        }
    }
}


// MARK: Private Methods -
extension JCAccountManager {
    
    /**
     *  Get one's login session. (`URL`...)
     *
     *  - Parameters:
     *      - completion: A block of what you wanna do with the login session.
     */
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

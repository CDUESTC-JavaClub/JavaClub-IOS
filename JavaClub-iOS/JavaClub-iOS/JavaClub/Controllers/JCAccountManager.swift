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
     *      - completion: A block of what you wanna do with the user's info.
     */
    func login(info: JCLoginInfo, _ completion: @escaping (JCUser?) -> Void) {
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
                            let userJson = (try JSON(data: data))["data"]
                            let user = JCUser(
                                username: userJson["username"].stringValue,
                                email: userJson["bindEmail"].stringValue,
                                redirectionURL: userJson["index"].stringValue,
                                avatar: userJson["headerUrl"].stringValue.isEmpty
                                    ? nil
                                    : userJson["headerUrl"].stringValue,
                                banner: userJson["backgroundUrl"].stringValue.isEmpty
                                    ? nil
                                    : userJson["backgroundUrl"].stringValue,
                                signature: userJson["signature"].stringValue.isEmpty
                                    ? nil
                                    : userJson["signature"].stringValue,
                                studentID: userJson["bindId"].stringValue.isEmpty
                                    ? nil
                                    : userJson["bindId"].stringValue
                            )
                            
                            completion(user)
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
                            completion(true)
                            print("DEBUG: Binding Successful.")
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
                    print("DEBUG: Logged Out Successfully.")
                }
            } catch {
                print("ERR: \(error.localizedDescription)")
            }
        }
    }
}

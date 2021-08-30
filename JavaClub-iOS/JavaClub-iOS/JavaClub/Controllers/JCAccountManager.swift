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
    
    func requestPubKey(_ completion: @escaping (String) -> Void) {
        AF.request("http://47.106.209.45:8080/api/auth/public-key").response { response in
            guard let data = response.data else { return }
            
            do {
                let jsonStr = (try JSON(data: data))["data"].stringValue
                completion(jsonStr)
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func login(info: JCLoginInfo, _ completion: @escaping (JCUser?) -> Void) {
        requestPubKey { key in
            
            do {
                let pubKey = try PublicKey(pemEncoded: key)
                let clear = try ClearMessage(string: info.password, using: .utf8)
                let encrypted = try clear.encrypted(with: pubKey, padding: .PKCS1)
                let parameters = [
                    "id": info.username,
                    "password": encrypted.base64String,
                    "remember-me": "false"
                ]
                
                AF.request(
                    "http://47.106.209.45:8080/api/auth/login",
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
                        print("ERROR: (Load JSON) \(error.localizedDescription)")
                        completion(nil)
                    }
                }
            } catch {
                print("ERROR: (Encrypt) \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}

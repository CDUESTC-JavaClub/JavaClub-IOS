//
//  JCAccountManager.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import Foundation
import Alamofire

class JCAccountManager {
    static let shared = JCAccountManager()
    
    private init() {}
}


extension JCAccountManager {
    
    func requestPubKey() -> String? {
        AF.request("http://47.106.209.45:8080//api/auth/public-key").response { response in
            
        }
    }
    
    func login(info: LoginInfo) -> String? {
        
    }
}

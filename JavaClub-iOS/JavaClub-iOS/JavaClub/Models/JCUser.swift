//
//  JCUser.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import Foundation

struct JCUser {
    let id = UUID().uuidString
    
    var username: String
    var email: String
    var redirectionURL: String
    var avatar: String?
    var banner: String?
    var signature: String?
    var studentID: String?
}

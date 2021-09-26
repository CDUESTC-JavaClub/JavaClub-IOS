//
//  JCUser.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import Foundation
import Defaults

struct JCUser: Equatable, Codable, DefaultsSerializable {
    var username: String
    var email: String
    var signature: String?
    var studentID: String?
}

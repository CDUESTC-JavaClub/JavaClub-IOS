//
//  BaiAccount.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/10/4.
//

import Foundation
import Defaults

struct BAAccount: Codable, DefaultsSerializable {
    var token: String
    
    var userName: String
    var sex: String
    var headImgUrl: String
    var identity: String
    var phone: String
    var userId: String
    var major: String
    var _class: String
}

//
//  JCLoginInfo.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import Foundation
import Defaults

struct JCLoginInfo: Codable, DefaultsSerializable {
    var username: String
    var password: String
}

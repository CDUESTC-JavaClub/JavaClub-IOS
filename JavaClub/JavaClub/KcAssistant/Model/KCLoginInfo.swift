//
//  KCLoginInfo.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/12.
//

import Foundation
import Defaults

struct KCLoginInfo: Codable, DefaultsSerializable {
    var id: String
    var password: String
}

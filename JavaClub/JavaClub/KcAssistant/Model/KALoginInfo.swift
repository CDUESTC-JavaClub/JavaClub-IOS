//
//  KALoginInfo.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/12.
//

import Foundation
import Defaults

struct KALoginInfo: Codable, DefaultsSerializable {
    var id: String
    var password: String
}

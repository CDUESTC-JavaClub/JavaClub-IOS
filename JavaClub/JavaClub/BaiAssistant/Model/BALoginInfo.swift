//
//  BALoginInfo.swift
//  JavaClub
//
//  Created by Roy on 2021/11/1.
//

import Foundation
import Defaults

struct BALoginInfo: Codable, DefaultsSerializable {
    var id: String
    var password: String
}

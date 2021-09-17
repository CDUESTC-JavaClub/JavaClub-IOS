//
//  KAClass.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/14.
//

import Foundation

struct KAClass: Identifiable, Hashable {
    let id = UUID().uuidString
    
    var name: String
    var classroom: String
    var teacher: String
    var time: String
}

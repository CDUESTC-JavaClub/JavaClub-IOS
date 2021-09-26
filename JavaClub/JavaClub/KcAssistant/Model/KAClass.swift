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
    var _id: String
    var teacher: String
    var locale: String
    var day: String
    var indexSet: [Int64]
    var weekSet: [Int64]
}


struct ClassIndex {
    static let first = [1, 2]
    static let second = [3, 4]
    static let third = [5, 6]
    static let forth = [7, 8]
    static let fifth = [9, 10]
    static let morning = [1, 2, 3, 4]
    static let afternoon = [5, 6, 7, 8]
    static let evening = [9, 10, 11]
}

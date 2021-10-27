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
    var classID: String
    var teacher: String
    var locale: String
    var day: Int
    var index: Int
    var weekFrom: Int
    var weekTo: Int
    var form: ClassForm
}


struct ClassIndex {
    static let first: [Int] = [1, 2]
    static let second: [Int] = [3, 4]
    static let third: [Int] = [5, 6]
    static let forth: [Int] = [7, 8]
    static let fifth: [Int] = [9, 10]
    static let morning: [Int] = [1, 2, 3, 4]
    static let afternoon: [Int] = [5, 6, 7, 8]
    static let evening: [Int] = [9, 10, 11]
    static let error: [Int] = [0]
}


enum ClassForm: String {
    case regular
    case singular
    case even
}

//
//  KAScore.swift
//  JavaClub
//
//  Created by Roy on 2021/9/29.
//

import Foundation

struct KAScore: Hashable, Identifiable {
    let id = UUID().uuidString
    
    var year: String
    var term: Int
    var className: String
    var classCode: String
    var classIndex: String
    var classType: String
    var points: Double
    var credits: Double
    var score: Double
    var redoScore: Double
}

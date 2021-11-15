//
//  ScoreAdd.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/10/4.
//

import Foundation

struct BAScoreAdding: Hashable {
    var eventName: String
    var eventID: Int
    var score: Int
    // 加分类型
    var type: String
    // 加分理由
    var reason: String
}

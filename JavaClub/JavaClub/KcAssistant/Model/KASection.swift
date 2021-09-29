//
//  KASection.swift
//  JavaClub
//
//  Created by Roy on 2021/9/29.
//

import Foundation

struct KASection: Hashable, Identifiable {
    let id = UUID().uuidString
    
    var title: String
    var scores: [KAScore]
}

//
//  Tab.swift
//  NBAer
//
//  Created by Roy Rao on 2021/8/16.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case club = "nav_home"
    case kc = "nav_kc"
    case bai = "nav_bai"
    case settings = "nav_settings"
    
    func label() -> String {
        switch self {
        case .club:
            return "JavaClub"
            
        case .kc:
            return "教务"
            
        case .bai:
            return "百叶计划"
            
        case .settings:
            return "设置"
        }
    }
}

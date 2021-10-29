//
//  NumberExtension.swift
//  JavaClub
//
//  Created by Roy on 2021/10/28.
//

import Foundation

extension Int {
    
    var chinese: String? {
        let userLocale = Locale(identifier: "zh_Hans_CN")
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = userLocale
        
        return formatter.string(for: self)
    }
}


extension Double {
    
    var chinese: String? {
        let userLocale = Locale(identifier: "zh_Hans_CN")
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = userLocale
        
        return formatter.string(for: self)
    }
}

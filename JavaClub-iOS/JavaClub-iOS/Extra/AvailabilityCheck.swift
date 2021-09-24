//
//  AvailabilityCheck.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/4.
//

import Foundation

extension Bool {
    
    static var macOS10_15: Bool {
        if #available(macOS 10.15, *) {
            return true
        } else {
            return false
        }
    }
    
    static var macOS11: Bool {
        if #available(macOS 11.0, *) {
            return true
        } else {
            return false
        }
    }
    
    static var iOS13: Bool {
        if #available(iOS 13.0, *) {
            return true
        } else {
            return false
        }
    }
    
    static var iOS14: Bool {
        if #available(iOS 14.0, *) {
            return true
        } else {
            return false
        }
    }
    
    static var iOS15: Bool {
        if #available(iOS 15.0, *) {
            return true
        } else {
            return false
        }
    }
}

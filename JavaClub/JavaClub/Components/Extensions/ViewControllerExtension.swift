//
//  ViewControllerExtension.swift
//  JavaClub
//
//  Created by Roy on 2021/9/28.
//

#if canImport(UIKit)

import UIKit

extension UIViewController {
    
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }
}

#endif

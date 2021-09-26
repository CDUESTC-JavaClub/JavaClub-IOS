//
//  JCLoginState.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/9/25.
//

import Foundation
import Defaults

extension Notification.Name {
    static let didUpdateLoginState = Notification.Name("didUpdateLoginStateName")
    static let didUpdateBindingState = Notification.Name("didUpdateBindingStateName")
}

class JCLoginState: ObservableObject {
    static let shared = JCLoginState()
    
    @Published var isLoggedIn: Bool {
        didSet {
            NotificationCenter.default.post(name: .didUpdateLoginState, object: nil)
        }
    }
    
    @Published var isBound: Bool {
        didSet {
            NotificationCenter.default.post(name: .didUpdateBindingState, object: nil)
        }
    }
    
    private init() {
        isLoggedIn = Defaults[.loginInfo] != nil
        isBound = Defaults[.bindingInfo] != nil
    }
}

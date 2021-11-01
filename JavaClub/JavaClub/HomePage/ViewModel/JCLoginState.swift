//
//  JCLoginState.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/9/25.
//

import Foundation
import Defaults

extension Notification.Name {
    static let didUpdateJCLoginState = Notification.Name("didUpdateJCLoginStateName")
    static let didUpdateJWLoginState = Notification.Name("didUpdateJWLoginStateName")
    static let didUpdateBYLoginState = Notification.Name("didUpdateBYLoginStateName")
    static let didUpdateBindingState = Notification.Name("didUpdateBindingStateName")
}

class JCLoginState: ObservableObject {
    static let shared = JCLoginState()
    
    @Published var jc: Bool {
        didSet {
            NotificationCenter.default.post(name: .didUpdateJCLoginState, object: nil)
        }
    }
    
    @Published var jw: Bool {
        didSet {
            NotificationCenter.default.post(name: .didUpdateJWLoginState, object: nil)
        }
    }
    
    @Published var by: Bool {
        didSet {
            NotificationCenter.default.post(name: .didUpdateJWLoginState, object: nil)
        }
    }
    
    @Published var isBound: Bool {
        didSet {
            NotificationCenter.default.post(name: .didUpdateBindingState, object: nil)
        }
    }
    
    private init() {
        jc = Defaults[.loginInfo] != nil
        jw = Defaults[.jwInfo] != nil
        by = Defaults[.byInfo] != nil
        isBound = Defaults[.user]?.studentID != nil
    }
}

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
}

class JCLoginState: ObservableObject {
    static let shared = JCLoginState()
    
    @Published var jc: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .didUpdateJCLoginState, object: nil, userInfo: [0: jc])
        }
    }
    
    @Published var jw: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .didUpdateJWLoginState, object: nil, userInfo: [0: jw])
        }
    }
    
    @Published var by: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .didUpdateBYLoginState, object: nil, userInfo: [0: by])
        }
    }
    
    @Published var isBound: Bool
    
    private init() {
        isBound = Defaults[.jcUser]?.studentID != nil
    }
    
    func logout() {
        jc = false
        jw = false
        by = false
    }
}

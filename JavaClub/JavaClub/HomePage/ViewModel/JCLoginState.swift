//
//  JCLoginState.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/9/25.
//

import Combine

class JCLoginState {
    static let shared = JCLoginState()
    
    var isLoggedIn: Bool = false
    var isBound: Bool = false
    
    private init() {}
}

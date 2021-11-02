//
//  JCLoginState.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/9/25.
//

import Foundation
import Defaults

class JCLoginState: ObservableObject {
    static let shared = JCLoginState()
    
    @Published var jc: Bool
    
    @Published var jw: Bool
    
    @Published var by: Bool
    
    @Published var isBound: Bool
    
    private init() {
        jc = !Defaults[.jcLoginInfo].isNil
        jw = !Defaults[.jwLoginInfo].isNil
        by = !Defaults[.byLoginInfo].isNil
        isBound = Defaults[.jcUser]?.studentID != nil
    }
}

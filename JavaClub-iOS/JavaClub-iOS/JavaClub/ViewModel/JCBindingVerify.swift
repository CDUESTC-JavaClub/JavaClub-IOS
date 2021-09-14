//
//  JCBindingVerify.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/12.
//

import SwiftUI
import Defaults

class JCBindingVerify: ObservableObject {
    static let shared = JCBindingVerify()
    
    @Published var verified: Bool = Defaults[.user]?.studentID != nil
    
    private init() {}
}

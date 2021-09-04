//
//  JCUserState.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import Foundation

class JCUserState: ObservableObject {
    static let shared = JCUserState()
    @Published var isLoggedIn: Bool = false
    @Published var url: String = ""
    @Published var currentUser: JCUser?
    
    private init() {}
}

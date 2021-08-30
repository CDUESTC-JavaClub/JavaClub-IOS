//
//  JCContentView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI

struct JCContentView: View {
    @ObservedObject var state: JCUserState = JCUserState.shared
    
    var body: some View {
        JCWebView(isLoggedIn: $state.isLoggedIn, url: $state.url)
    }
}

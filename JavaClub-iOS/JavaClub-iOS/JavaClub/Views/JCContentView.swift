//
//  JCContentView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI
import Defaults

struct JCContentView: View {
    @ObservedObject var state: JCUserState = JCUserState.shared
    @State private var showingLogin: Bool = false
    @Default(.rememberedUser) var rememberedUser
    
    var body: some View {
        if state.isLoggedIn, !state.url.isEmpty {
            JCWebView(url: $state.url)
        } else {
            if rememberedUser == nil {
                Button {
                    showingLogin = true
                } label: {
                    ZStack {
                        Circle()
                            .foregroundColor(Color.white)
                            .frame(width: 40, height: 40)
                            .shadow(radius: 5)
                            .opacity(0.5)
                        
                        Text("Login".localized())
                            .fixedSize()
                    }
                }
                .sheet(isPresented: $showingLogin) {
                    JCLoginView(showingLogin: $showingLogin, rememberedUser: $rememberedUser)
                }
            } else {
                Text("登陆中...")
                    .font(.title)
                    .fixedSize()
            }
        }
    }
}

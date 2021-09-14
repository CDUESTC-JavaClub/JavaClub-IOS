//
//  JCContentView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI
import Defaults

struct JCContentView: View {
    @State private var showingLogin: Bool = false
    @Default(.loginInfo) var loginInfo
    @Default(.sessionURL) var sessionURL
    @Default(.sessionExpired) var sessionExpired
    
    var body: some View {
        if sessionURL != nil {
            JCWebView(url: $sessionURL, sessionExpired: $sessionExpired)
        } else {
            if loginInfo == nil {
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
                    JCLoginView(showingLogin: $showingLogin, loginInfo: $loginInfo)
                }
            } else {
                Text("登陆中...")
                    .font(.title)
                    .fixedSize()
            }
        }
    }
}

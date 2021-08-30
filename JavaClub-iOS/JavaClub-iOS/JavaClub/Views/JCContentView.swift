//
//  JCContentView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI

struct JCContentView: View {
    @ObservedObject var state: JCUserState = JCUserState.shared
    @State private var showingLogin: Bool = false
    
    var body: some View {
        if state.isLoggedIn, !state.url.isEmpty {
            JCWebView(url: $state.url)
        } else {
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
                JCLoginView(showingLogin: $showingLogin)
            }
        }
    }
}

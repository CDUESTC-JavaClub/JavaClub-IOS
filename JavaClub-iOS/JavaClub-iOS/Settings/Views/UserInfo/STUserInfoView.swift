//
//  STUserInfoView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/5.
//

import SwiftUI

struct STUserInfoView: View {
    @ObservedObject var state = JCUserState.shared
    
    var body: some View {
        VStack {
            STHeaderView(user: $state.currentUser)
                .frame(height: 290)
                .edgesIgnoringSafeArea(.horizontal)
                .padding(.bottom, 10)
            
            Text(state.currentUser?.username ?? "")
                .font(.system(size: 20, design: .monospaced))
                .padding(.bottom, 5)
            
            Text(state.currentUser?.signature ?? "")
                .font(.system(size: 12, design: .monospaced))
        }
        .edgesIgnoringSafeArea(.top)
    }
}

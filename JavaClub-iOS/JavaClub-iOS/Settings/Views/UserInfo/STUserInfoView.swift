//
//  STUserInfoView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/5.
//

import SwiftUI
import Defaults

struct STUserInfoView: View {
    @Binding var user: JCUser?
    
    var body: some View {
        VStack {
            STHeaderView(user: $user)
                .frame(height: 290)
                .edgesIgnoringSafeArea(.horizontal)
                .padding(.bottom, 10)
            
            Text(user?.username ?? "N/A")
                .font(.system(size: 20, design: .monospaced))
                .padding(.bottom, 5)
            
            Text(user?.signature ?? "N/A")
                .font(.system(size: 12, design: .monospaced))
        }
        .edgesIgnoringSafeArea(.top)
    }
}

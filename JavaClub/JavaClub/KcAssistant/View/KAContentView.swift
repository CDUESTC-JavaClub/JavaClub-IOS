//
//  KAContentView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI
import Defaults

struct KAContentView: View {
    @ObservedObject private var verify = JCLoginState.shared
    
    var body: some View {
        if verify.isLoggedIn, verify.isBound {
            VStack {
                Form {
                    KAHeaderView()
                    
                    KAUserInfoView()
                    
                    KAAnnouncementView()
                    
                    KAActionView()
                }
                .listStyle(PlainListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .offset(y: -40)
                
                Spacer()
            }
        } else {
            JCBindIDView(verifyLogin: $verify.isLoggedIn, verifyBinding: $verify.isBound)
        }
    }
}

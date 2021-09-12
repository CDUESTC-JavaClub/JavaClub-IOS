//
//  KAContentView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI
import Defaults

struct KAContentView: View {
    @ObservedObject private var verify = JCBindingVerify.shared
    
    var body: some View {
        if verify.verified {
            VStack {
                Form {
                    KAHeaderView()
                    
                    KAUserInfoView()
                    
                    KAAnnouncementView()
                    
                    KAActionView()
                }
                .listStyle(PlainListStyle())
                .environment(\.horizontalSizeClass, .regular)
                .offset(y: -50)
                
                Spacer()
            }
        } else {
            JCBindIDView(verify: $verify.verified)
        }
    }
}

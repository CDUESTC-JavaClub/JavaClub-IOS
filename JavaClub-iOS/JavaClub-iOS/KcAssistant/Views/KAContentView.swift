//
//  KAContentView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI

struct KAContentView: View {
    
    var body: some View {
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
    }
}

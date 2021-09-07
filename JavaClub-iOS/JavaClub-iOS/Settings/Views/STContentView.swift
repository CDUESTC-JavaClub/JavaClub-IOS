//
//  STContentView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import UIKit
import SwiftUI
import Defaults

struct STContentView: View {
    @Default(.user) var user
    
    var body: some View {
        VStack {
            STUserInfoView(user: $user)
            
            Form {
                STBindingView(user: $user)
                
                STOptionView()
                
                STActionView()
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .offset(y: -50)
            
            Spacer()
        }
    }
}

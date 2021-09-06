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
        List {
            VStack {
                STUserInfoView(user: $user)
                
                Spacer()
            }
        }
    }
}

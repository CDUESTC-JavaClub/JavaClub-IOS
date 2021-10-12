//
//  BAContentView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI
import Defaults

struct BAContentView: View {
    @ObservedObject private var verify = JCLoginState.shared
    @Default(.enrollment) private var enrollment
    @Default(.jwInfo) private var jwInfo
    
    var body: some View {
        if verify.jc, verify.jw {
            VStack {
                Form {
                    BaiHeaderView()
                    
                    BaiUserInfoView()
                    
                    BaiActionView()
                }
                .listStyle(PlainListStyle())
                .environment(\.horizontalSizeClass, .regular)
                
                Spacer()
            }
        } else {
            Text("Please Bind")
        }
    }
}

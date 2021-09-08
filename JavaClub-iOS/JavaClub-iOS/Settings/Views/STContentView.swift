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
    @Environment(\.colorScheme) private var scheme
    @Default(.user) private var user
    
    var body: some View {
        VStack {
            STUserInfoView(user: $user)
            
            Form {
                JCNoticeView(textStr: "你可以对你的学号（教务账号）、百叶计划账号进行绑定，我们只会在云端保存你的学号，个人信息和密码都存储在本地，并且这些敏感信息会随着软件卸载一并移除。")
                
                STBindingView(user: $user)
                
                STOptionView()
                
                STActionView()
            }
            .listStyle(PlainListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .offset(y: -50)
            
            Spacer()
        }
        .background(scheme == .light ? Color(hex: "F2F2F7") : .black)
    }
}

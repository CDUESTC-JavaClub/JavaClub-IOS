//
//  STBindingView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/7.
//

import SwiftUI

struct STBindingView: View {
    @Binding var user: JCUser?
    
    var body: some View {
        Section(header: Text("个人信息")) {
            HStack {
                Text("已绑定学号")
                
                Spacer()
                
                Text(user?.studentID ?? "无")
                    .foregroundColor(.secondary)
                    .font(.callout)
            }
            
            HStack {
                Text("已绑定邮箱")
                
                Spacer()
                
                Text(user?.email ?? "无")
                    .foregroundColor(.secondary)
                    .font(.callout)
            }
        }
    }
}

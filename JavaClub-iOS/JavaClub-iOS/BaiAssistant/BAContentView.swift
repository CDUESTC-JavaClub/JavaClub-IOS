//
//  BAContentView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI

struct BAContentView: View {
    
    var body: some View {
        VStack {
            Form {
                AnnouncementView(textStr: "以下功能模块的网络请求，会直接访问教务系统接口，无需经过App服务器进行数据传输或中转，全力保证个人隐私数据不会泄露。")
                
                BaiActionView()
            }
            .listStyle(PlainListStyle())
            .environment(\.horizontalSizeClass, .regular)
            
            Spacer()
        }
    }
}

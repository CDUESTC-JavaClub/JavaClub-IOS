//
//  KAAnnouncementView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/8.
//

import SwiftUI

struct KAAnnouncementView: View {
    
    var body: some View {
        Section {
            HStack {
                Image("kc_annouce")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("暂无公告内容，敬请期待~")
                    .foregroundColor(.secondary)
            }
        }
    }
}

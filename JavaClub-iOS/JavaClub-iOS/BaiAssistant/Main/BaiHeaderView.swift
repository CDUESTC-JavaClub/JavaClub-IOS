//
//  BaiHeaderView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/8.
//

import SwiftUI

struct BaiHeaderView: View {
    
    var body: some View {
        Section {
            HStack {
                Image("bai")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading) {
                    Text("百叶计划")
                        .font(.title)
                        .foregroundColor(.white)
                    
                    Text("包含活动报名、活动取消、积分查询等功能")
                        .font(.footnote)
                        .foregroundColor(.white)
                }
            }
            .listRowBackground(Color(hex: "52A0ED"))
            
            JCNoticeView(textStr: "以下功能模块的网络请求，会直接访问教务系统接口，无需经过App服务器进行数据传输或中转，全力保证个人隐私数据不会泄露。")
        }
    }
}

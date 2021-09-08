//
//  BaiScoreOverallView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/8.
//

import SwiftUI

struct BaiScoreOverallView: View {
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Roy")
                    .font(.title)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 2)
                
                Text("计算机类 虚拟现实1班")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                
                Text("06工坊 Uppower")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Divider()
                .padding(.vertical, 3)
                .padding(.trailing, 3)
            
            VStack {
                Text("80")
                    .font(.largeTitle)
                    .foregroundColor(Color(hex: "89C8B0"))
                
                Text("已达标")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }
}

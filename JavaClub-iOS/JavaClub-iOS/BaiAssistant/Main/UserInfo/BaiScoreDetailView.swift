//
//  BaiScoreDetailView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/8.
//

import SwiftUI

struct BaiScoreDetailView: View {
    
    var body: some View {
        HStack {
            Image("bai_score")
                .resizable()
                .frame(width: 120, height: 125)
            
            VStack {
                HStack(alignment: .center) {
                    BaiScoreMiniView(
                        image: "bai_icon_bx",
                        score: "12",
                        name: "博学",
                        color: Color(hex: "B4483F")
                    )
                    
                    Divider()
                        .padding(.vertical, 3)
                        .padding(.horizontal)
                    
                    BaiScoreMiniView(
                        image: "bai_icon_jm",
                        score: "38",
                        name: "尽美",
                        color: Color(hex: "EFCB68")
                    )
                }
                
                Divider()
                
                HStack(alignment: .center) {
                    BaiScoreMiniView(
                        image: "bai_icon_dx",
                        score: "10",
                        name: "笃行",
                        color: Color(hex: "6A9C65")
                    )
                    
                    Divider()
                        .padding(.vertical, 3)
                        .padding(.horizontal)
                    
                    BaiScoreMiniView(
                        image: "bai_icon_md",
                        score: "12",
                        name: "尽美",
                        color: Color(hex: "568FC6")
                    )
                }
            }
        }
    }
}

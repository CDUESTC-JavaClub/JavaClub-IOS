//
//  BaiScoreMiniView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/8.
//

import SwiftUI

struct BaiScoreMiniView: View {
    var image: String
    var score: String
    var name: String
    var color: Color
    
    var body: some View {
        VStack {
            HStack {
                Image(image)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(color)
                    
                
                Text(score)
                    .font(.callout)
                    .foregroundColor(color)
            }
            
            Text(name)
                .font(.callout)
                .foregroundColor(.secondary)
        }
    }
}

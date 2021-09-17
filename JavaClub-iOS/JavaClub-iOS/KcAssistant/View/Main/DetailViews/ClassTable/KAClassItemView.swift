//
//  KAClassItemView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/17.
//

import SwiftUI

struct KAClassItemView: View {
    let item: KAClass
        
    var body: some View {
        GeometryReader { geo in
            let fontSize = min(geo.size.width * 0.2, 28)
            
            VStack(spacing: 3) {
                Text(item.time)
                    .font(.system(size: fontSize, design: .rounded))
                
                Text(item.name)
                    .font(.system(size: fontSize, weight: .bold, design: .rounded))
                
                Text(item.classroom.isEmpty ? "" : "@\(item.classroom)")
                    .font(.system(size: fontSize, design: .rounded))
                
                Text(item.teacher.isEmpty ? "" : "「\(item.teacher)」")
                    .font(.system(size: fontSize, design: .rounded))
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(!item.name.isEmpty ? Color.blue.opacity(0.2) : .clear)
        }
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

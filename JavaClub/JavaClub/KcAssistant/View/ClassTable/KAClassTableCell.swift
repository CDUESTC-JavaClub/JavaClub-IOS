//
//  KAClassTableCell.swift
//  JavaClub
//
//  Created by Roy on 2021/10/15.
//

import SwiftUI

struct KAClassTableCell: View {
    var className: String
    var location: String
    var teacher: String
    var color: Color
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 5) {
                Text(className)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                
                Text(className.isEmpty ? "" : "(\(teacher))")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
                
                Text(className.isEmpty ? "" : "@\(location)")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(className.isEmpty ? .clear : color)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

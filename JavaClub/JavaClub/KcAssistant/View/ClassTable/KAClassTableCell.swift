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
    var isBlank: Bool
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 5) {
                Text(isBlank ? "" : "\(className)")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                
                Text(isBlank ? "" : "(\(teacher))")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
                
                Text(isBlank ? "" : "@\(location)")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(isBlank ? nil : Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

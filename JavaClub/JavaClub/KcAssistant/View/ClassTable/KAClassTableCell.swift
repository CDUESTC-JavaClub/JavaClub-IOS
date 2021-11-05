//
//  KAClassTableCell.swift
//  JavaClub
//
//  Created by Roy on 2021/10/15.
//

import SwiftUI

struct KAClassTableCell: View {
    var _class: KAClass
    var color: Color
    var onTapGesture: ((KAClass) -> Void)?
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 5) {
                if _class.form == .singular {
                    Text("单周".localized())
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                } else if _class.form == .even {
                    Text("双周".localized())
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                
                Text(_class.name)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                
                Text(_class.name.isEmpty ? "" : "(\(_class.teacher))")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
                
                Text(_class.name.isEmpty ? "" : "@\(_class.locale)")
                    .font(.system(size: 10))
                    .foregroundColor(.white)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .background(_class.name.isEmpty ? .clear : color)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .onTapGesture {
                onTapGesture?(_class)
            }
        }
    }
}

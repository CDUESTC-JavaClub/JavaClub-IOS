//
//  CheckBoxView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI

struct CheckBoxView: View {
    @Binding var checked: Bool
    var label: String

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: checked ? "checkmark.square.fill" : "square")
                .foregroundColor(checked ? Color(hex: "5729E5") : .secondary)
            
            Text("自动登录")
                .foregroundColor(.black)
                .fixedSize()
                .padding(.leading, 5)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            checked.toggle()
        }
    }
}

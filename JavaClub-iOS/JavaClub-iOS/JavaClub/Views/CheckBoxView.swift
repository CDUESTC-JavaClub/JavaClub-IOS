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
        HStack {
            Image(systemName: checked ? "checkmark.square.fill" : "square")
                .foregroundColor(checked ? Color(hex: "5729E5") : .secondary)
                .onTapGesture {
                    self.checked.toggle()
                }
            
            Text("自动登录")
                .font(.caption)
                .fixedSize()
                .padding(.leading, 5)
        }
        .contentShape(Rectangle())
    }
}

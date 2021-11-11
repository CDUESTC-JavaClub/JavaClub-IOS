//
//  KATermSelectorView.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/10/27.
//

import SwiftUI

struct KATermSelectorView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isShown: Bool
    @Binding var selected: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(alignment: .top) {
                Spacer()
                
                Button {
                    isShown = false
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.label)
                }
                .padding(.trailing, 10)
            }
            .frame(width: 250, height: 20)
            .padding(.top, 10)
            
            ForEach(1 ..< (JCTermManager.shared.term() ?? 0) + 1) { index in
                Button {
                    selected = index
                    isShown = false
                } label: {
                    Text(JCTermManager.shared.formatted(for: index) ?? "获取失败...".localized())
                        .foregroundColor(selected == index ? Color(hex: "413258") : .accentColor)
                }
                .frame(width: 250, height: 20)
                .padding(.vertical, 5)
            }
        }
        .padding(.bottom, 20)
        .background(colorScheme == .light ? Color.white : .gray)
        .cornerRadius(15)
    }
}

//
//  TabBarView.swift
//  NBAer
//
//  Created by Roy Rao on 2021/8/16.
//

import SwiftUI

struct TabBarView: View {
    @Environment(\.colorScheme) var scheme
    @Binding var selected: Tab
    @Binding var centerX: CGFloat
    private let bottomInsets = UIApplication.shared.windows.first?.safeAreaInsets.bottom
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { item in
                GeometryReader { geo in
                    TabBarButton(
                        selected: $selected,
                        id: item,
                        centerX: $centerX,
                        rect: geo.frame(in: .global)
                    )
                    .onAppear {
                        if item == Tab.allCases.first {
                            centerX = geo.frame(in: .global).midX
                        }
                    }
                }
                .frame(width: 70, height: 50)
                
                if item != Tab.allCases.last {
                    Spacer(minLength: 0)
                }
            }
        }
        .padding(.horizontal, 25)
        .padding(.top)
        // Smaller size iPhones will have 15 padding while notch iPhones not
        .padding(.bottom, bottomInsets == 0 ? 15 : bottomInsets)
        .background(
            (scheme == .light ? Color.white : Color.black)
                .clipShape(AnimatedShape(centerX: centerX))
        )
        .shadow(
            color: (scheme == .light ? Color.black : .white).opacity(0.1),
            radius: 5, x: 0, y: -5
        )
        .padding(.top, -15)
    }
}

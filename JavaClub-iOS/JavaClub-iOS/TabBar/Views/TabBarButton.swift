//
//  TabBarButton.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI

struct TabBarButton: View {
    @Binding var selected: Tab
    var id: Tab
    @Binding var centerX: CGFloat
    var rect: CGRect
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                selected = id
                centerX = rect.midX
            }
        } label: {
            VStack {
                Image(id.rawValue)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 26, height: 26)
                    .foregroundColor(
                        selected == id
                            ? Color(hex: "8971D5")
                            : .secondary
                    )
                
                Text(id.label())
                    .font(.caption)
                    .foregroundColor(Color(.label))
                    .opacity(
                        selected == id
                            ? 1
                            : 0
                    )
            }
            .padding(.top)
            .frame(width: 70, height: 50)
            .offset(y: selected == id ? -15 : 0)
        }
    }
}


struct AnimatedShape: Shape {
    var centerX: CGFloat
    
    var animatableData: CGFloat {
        get { centerX }
        set { centerX = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 15))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 15))
            
            // Draw curve
            path.move(to: CGPoint(x: centerX - 35, y: 15))
            path.addQuadCurve(
                to: CGPoint(x: centerX + 35, y: 15),
                control: CGPoint(x: centerX, y: -30)
            )
        }
    }
}

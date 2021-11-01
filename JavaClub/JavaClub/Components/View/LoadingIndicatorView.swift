//
//  LoadingIndicatorView.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/9/25.
//

import SwiftUI

struct LoadingIndicatorView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var animates = false
    private let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            GeometryReader { geo in
                HStack(alignment: .center, spacing: 5) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentColor)
                        .frame(width: 15, height: animates ? geo.size.height / 2 : geo.size.height)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentColor)
                        .frame(width: 15, height: animates ? geo.size.height : geo.size.height / 2)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentColor)
                        .frame(width: 15, height: animates ? geo.size.height / 2 : geo.size.height)
                }
                .animation(
                    Animation
                        .easeInOut(duration: 0.4)
                        .repeatForever(autoreverses: true)
                )
                
                Text("加载中")
                    .foregroundColor(Color.label)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .background(colorScheme == .light ? Color.white : .gray)
        .cornerRadius(15)
        .onAppear {
            animates = true
        }
    }
}

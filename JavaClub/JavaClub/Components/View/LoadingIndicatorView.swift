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
            Section {
                HStack(alignment: .center, spacing: 5) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentColor)
                        .frame(width: 15, height: animates ? 50 : 25)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentColor)
                        .frame(width: 15, height: animates ? 25 : 50)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.accentColor)
                        .frame(width: 15, height: animates ? 50 : 25)
                }
                .animation(
                    Animation
                        .easeInOut(duration: 0.4)
                        .repeatForever(autoreverses: true)
                )
            }
            .frame(width: 50, height: 50)
            
            Text("加载中")
                .foregroundColor(Color.label)
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

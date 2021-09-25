//
//  LoadingIndicatorView.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/9/25.
//

import SwiftUI

struct LoadingIndicatorView: View {
    @State private var animates = false
    private let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Section {
                HStack(alignment: .center, spacing: 5) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "80FBEB"))
                        .frame(width: 20, height: animates ? 70 : 20)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "80FBEB"))
                        .frame(width: 20, height: animates ? 20 : 50)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "80FBEB"))
                        .frame(width: 20, height: animates ? 70 : 20)
                }
                .animation(
                    Animation
                        .easeInOut(duration: 0.4)
                        .repeatForever(autoreverses: true)
                )
            }
            
            Text("加载中")
                .foregroundColor(Color.secondary)
        }
        .frame(width: 150, height: 150)
        .onAppear {
            animates = true
        }
    }
}

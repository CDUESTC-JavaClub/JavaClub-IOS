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
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 10) {
                Section {
                    HStack(alignment: .center, spacing: 5) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "60D1AE"))
                            .frame(width: 15, height: animates ? geo.size.height : geo.size.height * 0.5)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "60D1AE"))
                            .frame(width: 15, height: animates ? geo.size.height * 0.5 : geo.size.height)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "60D1AE"))
                            .frame(width: 15, height: animates ? geo.size.height : geo.size.height * 0.5)
                    }
                    .animation(
                        Animation
                            .easeInOut(duration: 0.4)
                            .repeatForever(autoreverses: true)
                    )
                }
                
                Text("加载中")
                    .foregroundColor(Color.label)
            }
        }
        .frame(width: 50, height: 50)
        .onAppear {
            animates = true
        }
    }
}

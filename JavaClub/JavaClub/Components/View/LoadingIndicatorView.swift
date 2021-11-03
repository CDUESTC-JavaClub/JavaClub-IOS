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
            Spinner(animates: animates)
                .frame(width: 30, height: 30)
                .padding(.top, 25)
            
            Spacer()
            
            Text("加载中")
                .foregroundColor(Color.label)
                .padding(.bottom, 10)
        }
        .background(colorScheme == .light ? Color.white : .gray)
        .cornerRadius(15)
        .frame(width: 100, height: 100)
        .onAppear {
            animates = true
        }
    }
}

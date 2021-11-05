//
//  Spinner.swift
//  JavaClub
//
//  Created by Roy on 2021/11/3.
//

import SwiftUI

// MARK: For SwiftUI -
struct Spinner: UIViewRepresentable {
    let animates: Bool
    
    func makeUIView(context: Context) -> ProgressView {
        let progress = ProgressView(
            colors: [UIColor(hex: "BB85E9") ?? .purple, UIColor(hex: "60D1AE") ?? .systemGreen],
            lineWidth: 5
        )
        progress.translatesAutoresizingMaskIntoConstraints = false
        
        return progress
    }
    
    func updateUIView(_ uiView: ProgressView, context: Context) {
        uiView.isAnimating = animates
    }
}

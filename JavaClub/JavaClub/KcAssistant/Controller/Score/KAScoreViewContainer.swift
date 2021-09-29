//
//  KAScoreViewContainer.swift
//  JavaClub
//
//  Created by Roy on 2021/9/29.
//

import SwiftUI

struct KAScoreViewContainer: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        KAScoreViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

//
//  ViewControllerExtension.swift
//  JavaClub
//
//  Created by Roy on 2021/9/28.
//

#if canImport(UIKit)

import UIKit
import SnapKit

fileprivate let indicatorView: ProgressView = {
    let progress = ProgressView(
        colors: [UIColor(hex: "BB85E9") ?? .purple, UIColor(hex: "60D1AE") ?? .systemGreen],
        lineWidth: 5
    )
    progress.translatesAutoresizingMaskIntoConstraints = false
    return progress
}()

extension UIViewController {
    
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }
    
    func initIndicator() {
        view.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
    
    func startLoading() {
        indicatorView.isAnimating = true
    }
    
    func stopLoading() {
        indicatorView.isAnimating = false
    }
}

#endif

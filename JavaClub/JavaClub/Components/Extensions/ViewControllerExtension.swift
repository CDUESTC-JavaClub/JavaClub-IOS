//
//  ViewControllerExtension.swift
//  JavaClub
//
//  Created by Roy on 2021/9/28.
//

#if canImport(UIKit)

import UIKit
import SnapKit

fileprivate let progressView = ProgressIndicator(frame: .zero)

extension UIViewController {
    
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }
    
    func startLoading() {
        progressView.foregroundColor = isDarkMode ? .gray : .white
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        progressView.resume()
    }
    
    func stopLoading() {
        progressView.removeFromSuperview()
        
        progressView.stop()
    }
}

#endif

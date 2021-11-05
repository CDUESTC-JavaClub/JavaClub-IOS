//
//  ViewControllerExtension.swift
//  JavaClub
//
//  Created by Roy on 2021/9/28.
//

import UIKit
import SnapKit

extension UIViewController {
    
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }
    
    func startLoading(for tag: ProgressTag) {
        let progressView = ProgressIndicator(frame: .zero)
        progressView.tag = tag.rawValue
        
        progressView.foregroundColor = isDarkMode ? .gray : .white
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        progressView.resume()
    }
    
    func stopLoading(for tag: ProgressTag) {
        if let progressView = view.viewWithTag(tag.rawValue) as? ProgressIndicator {
            progressView.stop()
            progressView.removeFromSuperview()
        }
    }
}


enum ProgressTag: Int {
    case jc = 1001
    case jw = 1002
    case by = 1003
}

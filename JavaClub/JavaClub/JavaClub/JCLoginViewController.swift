//
//  JCLoginViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/24.
//

import UIKit
import SwiftUI
import SnapKit

class JCLoginViewController: UIViewController {
    private let indicatorView = _UIHostingView(rootView: LoadingIndicatorView())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        showIndicator()
    }
}


extension JCLoginViewController {
    
    private func showIndicator() {
        view.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
//        indicatorView.animate(indicatorView.rectangle1, counter: 1)
//        indicatorView.animate(indicatorView.rectangle2, counter: 0)
//        indicatorView.animate(indicatorView.rectangle3, counter: 1)
    }
    
    private func removeIndicator() {
        indicatorView.snp.removeConstraints()
        
        indicatorView.removeFromSuperview()
    }
}

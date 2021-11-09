//
//  JCRefreshViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/11/9.
//

import UIKit

class JCRefreshViewController: UIViewController {
    var onTapGesture: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tap)
    }
}


extension JCRefreshViewController {
    
    @objc private func tapped() {
        onTapGesture?()
    }
}

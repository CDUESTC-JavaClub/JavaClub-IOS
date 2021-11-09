//
//  JCRefreshViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/11/9.
//

import UIKit

class JCRefreshViewController: UIViewController {
    @IBOutlet var hintLabel: LocalizableLabel!
    
    var onTapGesture: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tap)
    }
}


extension JCRefreshViewController {
    
    func updateLabelText(with textStr: String) {
        hintLabel.localizedKey = textStr
    }
    
    @objc private func tapped() {
        onTapGesture?()
    }
}

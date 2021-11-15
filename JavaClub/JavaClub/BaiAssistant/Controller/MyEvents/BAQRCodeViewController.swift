//
//  BAQRCodeViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/11/11.
//

import UIKit

class BAQRCodeViewController: UIViewController {
    @IBOutlet var backgroundView: UIVisualEffectView!
    @IBOutlet var verificationCodeLabel: UILabel!
    @IBOutlet var qrCodeView: UIImageView!
    @IBOutlet var resignBtn: LocalizableButton!
    
    var eventItem: BAEvent?
    var resignDidTap: (() -> Void)?
    var dismissHandler: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        backgroundView.addGestureRecognizer(tap)
    }
}


extension BAQRCodeViewController {
    
    private func initialize(with event: BAEvent?) {
        guard let event = event else { return }
        
        
    }
    
    @IBAction private func resignDidClick(_ sender: UIButton) {
        resignDidTap?()
    }
    
    @objc private func backgroundDidTap() {
        dismissHandler?()
    }
}

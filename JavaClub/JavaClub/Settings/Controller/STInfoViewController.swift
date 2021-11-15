//
//  STInfoViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/11/15.
//

import UIKit

class STInfoViewController: UIViewController {
    @IBOutlet var versionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        {
            versionLabel.text = "v\(version) (\(build))"
        }
    }
}


extension STInfoViewController {
    
    @IBAction private func joinGroupDidTap(_ sender: UIButton) {
        if let createURL = URL(string: "https://jq.qq.com/?_wv=1027&k=euhx2LOJ") {
            UIApplication.shared.open(createURL)
        }
    }
    
    @IBAction private func sendMailDidTap(_ sender: UIButton) {
        if
            let mailtoString = "mailto:royrao2333@126.com?subject=JavaClub iOS App 问题反馈"
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let mailtoURL = URL(string: mailtoString),
            UIApplication.shared.canOpenURL(mailtoURL)
        {
            UIApplication.shared.open(mailtoURL)
        }
    }
}

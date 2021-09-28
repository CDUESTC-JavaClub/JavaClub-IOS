//
//  JCLoginViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/24.
//

import UIKit
import SwiftUI
import Defaults
import SnapKit

class JCLoginViewController: UIViewController {
    private let indicatorView = _UIHostingView(rootView: LoadingIndicatorView())
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var createBtn: UIButton!
    @IBOutlet var ForgotBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


extension JCLoginViewController {
    
    @IBAction func login() {
        showIndicator()
        loginBtn.isEnabled = false
        createBtn.isEnabled = false
        ForgotBtn.isEnabled = false
        
        if
            let username = usernameField.text,
            let password = passwordField.text,
            !username.isEmpty,
            !password.isEmpty
        {
            let info = JCLoginInfo(username: username, password: password)
            JCAccountManager.shared.login(info: info) { [weak self] result in
                if let success = try? result.get(), success {
                    Defaults[.loginInfo] = info
                    
                    JCAccountManager.shared.getInfo { result in
                        let userInfo = try? result.get()
                        JCLoginState.shared.isLoggedIn = userInfo != nil
                        Defaults[.user] = userInfo
                    }
                    
                    JCAccountManager.shared.refreshCompletely()
                    
                    self?.dismiss(animated: true)
                    self?.removeIndicator()
                    UITabBar.appearance().isHidden = false
                    JCLoginState.shared.isLoggedIn = true
                }
            }
        }
    }
    
    private func showIndicator() {
        view.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
    }
    
    private func removeIndicator() {
        indicatorView.snp.removeConstraints()
        
        indicatorView.removeFromSuperview()
    }
}

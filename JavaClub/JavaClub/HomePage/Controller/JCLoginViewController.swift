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
        
        //DEBUG
        BaiAccountManage.initAccount(id: "1940618833", password: "123456")
        
        passwordField.isSecureTextEntry = true
    }
}


extension JCLoginViewController {
    
    @IBAction func login() {
        if
            let username = usernameField.text,
            let password = passwordField.text,
            !username.isEmpty,
            !password.isEmpty
        {
            showIndicator()
            
            let info = JCLoginInfo(username: username, password: password)
            JCAccountManager.shared.login(info: info) { [weak self] result in
                if let success = try? result.get(), success {
                    Defaults[.loginInfo] = info
                    
                    JCAccountManager.shared.getInfo { result in
                        let userInfo = try? result.get()
                        JCLoginState.shared.jc = userInfo != nil
                        Defaults[.user] = userInfo
                        
                        JCLoginState.shared.jc = true
                        JCLoginState.shared.isBound = userInfo?.studentID != nil
                    }
                    
                    JCAccountManager.shared.refreshCompletely()
                    
                    self?.dismiss(animated: true)
                    self?.removeIndicator()
                    UITabBar.appearance().isHidden = false
                } else {
                    self?.removeIndicator()
                    
                    let alert = UIAlertController(title: "提示", message: "登录失败，请检查输入或网络连接是否通畅！", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let alert = UIAlertController(title: "提示", message: "用户名和密码都不能为空，请检查输入！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func showIndicator() {
        view.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
        
        loginBtn.isEnabled = false
        createBtn.isEnabled = false
        ForgotBtn.isEnabled = false
    }
    
    private func removeIndicator() {
        indicatorView.snp.removeConstraints()
        
        indicatorView.removeFromSuperview()
        
        loginBtn.isEnabled = true
        createBtn.isEnabled = true
        ForgotBtn.isEnabled = true
    }
}

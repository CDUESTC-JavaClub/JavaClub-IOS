//
//  KABindingViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/24.
//

import UIKit
import SwiftUI
import Defaults
import SnapKit

class KABindingViewController: UIViewController {
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setup()
    }
}


extension KABindingViewController {
    
    private func setup() {
        loginBtn.setTitle("", for: .normal)
        loginBtn.layer.cornerRadius = loginBtn.frame.width / 2
        
        usernameField.layer.borderWidth = 1
        usernameField.layer.borderColor = UIColor.label.cgColor
        usernameField.layer.cornerRadius = usernameField.frame.height / 2
        usernameField.clipsToBounds = true
        usernameField.autocorrectionType = .no
        usernameField.keyboardType = .numberPad
        
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.label.cgColor
        passwordField.layer.cornerRadius = passwordField.frame.height / 2
        passwordField.clipsToBounds = true
        passwordField.autocorrectionType = .no
    }
    
    @IBAction func login() {
        if
            let username = usernameField.text,
            let password = passwordField.text,
            !username.isEmpty,
            !password.isEmpty
        {
            showIndicator()
            dismissKeyboard()
            tabBarEnabled(false)
            
            let info = KALoginInfo(id: username, password: password)
            
            JCAccountManager.shared.loginJW(
                info: info,
                bind: !JCLoginState.shared.isBound
            ) { [weak self] result in
                self?.removeIndicator()
                self?.tabBarEnabled(true)
                
                switch result {
                case .success(let success):
                    if success {
                        Defaults[.jwLoginInfo] = info

                        JCAccountManager.shared.getEnrollmentInfo { result in
                            if let enr = try? result.get() {
                                Defaults[.enrollment] = enr
                                JCLoginState.shared.jw = true
                            }
                        }
                    } else {
                        let alert = UIAlertController(title: "提示", message: "登录失败，请检查用户名和密码是否正确，或网络连接是否通畅！", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    if error == .notLoginJC {
                        let alert = UIAlertController(title: "提示", message: "使用教务功能之前，请先登录论坛账号！", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    } else if error == .wrongPassword {
                        let alert = UIAlertController(title: "提示", message: "用户名或密码错误，请检查输入。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "提示", message: "未知错误，请稍后再试。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "提示", message: "用户名和密码都不能为空，请检查输入！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func showIndicator() {
        startLoading()
        
        loginBtn.isEnabled = false
    }
    
    private func removeIndicator() {
        stopLoading()
        
        loginBtn.isEnabled = true
    }
    
    private func tabBarEnabled(_ boolean: Bool) {
        guard let tabItems = tabBarController?.tabBar.items else { return }
        
        if boolean {
            tabItems.forEach {
                $0.isEnabled = true
            }
        } else {
            tabItems.forEach {
                $0.isEnabled = false
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        usernameField.hideKeyboard()
        passwordField.hideKeyboard()
    }
}

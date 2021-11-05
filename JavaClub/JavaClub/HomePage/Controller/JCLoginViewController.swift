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
import DeviceKit

class JCLoginViewController: UIViewController {
    @IBOutlet var usernameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var createBtn: UIButton!
    @IBOutlet var forgotBtn: UIButton!
    @IBOutlet var agreeCheckBtn: JCCheckboxButton!
    @IBOutlet var privacyBtn: UIButton!
    @IBOutlet var interactionView: UIView!
    @IBOutlet var usernameContainerView: DesignableView!
    @IBOutlet var passwordContainerView: DesignableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        setup()
        configureAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        configureAppearance()
    }
}


extension JCLoginViewController {
    
    private func setup() {
        loginBtn.setTitle("", for: .normal)
        loginBtn.layer.cornerRadius = loginBtn.frame.width / 2
        
        usernameField.layer.borderWidth = 1
        usernameField.layer.cornerRadius = usernameField.frame.height / 2
        usernameField.clipsToBounds = true
        usernameField.autocorrectionType = .no
        usernameField.keyboardType = .alphabet
        
        passwordField.layer.borderWidth = 1
        passwordField.layer.cornerRadius = passwordField.frame.height / 2
        passwordField.clipsToBounds = true
        passwordField.autocorrectionType = .no
    }
    
    private func configureAppearance() {
        if isDarkMode {
            view.backgroundColor = UIColor(hex: "151515")
            interactionView.backgroundColor = UIColor(hex: "151515")
            usernameContainerView.backgroundColor = UIColor(hex: "151515")
            passwordContainerView.backgroundColor = UIColor(hex: "151515")
            usernameField.layer.borderColor = UIColor(hex: "C8C8C8")?.cgColor
            passwordField.layer.borderColor = UIColor(hex: "C8C8C8")?.cgColor
        } else {
            view.backgroundColor = UIColor(hex: "FFFFFF")
            interactionView.backgroundColor = UIColor(hex: "FFFFFF")
            usernameContainerView.backgroundColor = UIColor(hex: "FFFFFF")
            passwordContainerView.backgroundColor = UIColor(hex: "FFFFFF")
            usernameField.layer.borderColor = UIColor.black.cgColor
            passwordField.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBAction func login() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if
            let username = usernameField.text,
            let password = passwordField.text,
            !username.isEmpty,
            !password.isEmpty
        {
            
            if agreeCheckBtn.flag {
                showIndicator()
                dismissKeyboard()
                
                let info = JCLoginInfo(username: username, password: password)
                appDelegate?.loginJC(info) { [weak self] in
                    self?.removeIndicator()
                    JCAccountManager.shared.getUserMedia { success in
                        JCLoginState.shared.jc = success
                    }
                } onFailure: { [weak self] in
                    self?.removeIndicator()
                    
                    let alert = UIAlertController(title: "提示", message: "登录失败，请检查输入或网络连接是否通畅！".localized(), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "提示", message: "在使用本软件之前，您需要同意我们的隐私条款！".localized(), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            
        } else {
            let alert = UIAlertController(title: "提示", message: "用户名和密码都不能为空，请检查输入！".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func agreeCheckboxDidSwitch(_ sender: JCCheckboxButton) {
        sender.flag.toggle()
        
        if sender.flag {
            sender.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    
    @IBAction func privacyBtnDidClick(_ sender: UIButton) {
        if let privacyURL = URL(string: "https://study.cduestc.club/index.php?help/privacy-policy/") {
            UIApplication.shared.open(privacyURL)
        }
    }
    
    @IBAction func createBtnDidClick(_ sender: UIButton) {
        if let createURL = URL(string: "https://study.cduestc.club/index.php?register/") {
            UIApplication.shared.open(createURL)
        }
    }
    
    @IBAction func forgotBtnDidClick(_ sender: UIButton) {
        if let forgotURL = URL(string: "https://study.cduestc.club/index.php?lost-password/") {
            UIApplication.shared.open(forgotURL)
        }
    }
    
    private func showIndicator() {
        startLoading(for: .jc)
    }
    
    private func removeIndicator() {
        stopLoading(for: .jc)
    }
    
    @objc private func dismissKeyboard() {
        usernameField.hideKeyboard()
        passwordField.hideKeyboard()
    }
}

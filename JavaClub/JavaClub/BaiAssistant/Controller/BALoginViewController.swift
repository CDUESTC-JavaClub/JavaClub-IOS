//
//  BALoginViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/11/4.
//

import UIKit

import UIKit
import SwiftUI
import Defaults
import SnapKit

class BALoginViewController: UIViewController {
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


extension BALoginViewController {
    
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
            
            let info = BALoginInfo(id: username, password: password)
            
            
        } else {
            let alert = UIAlertController(title: "提示", message: "用户名和密码都不能为空，请检查输入！".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func showIndicator() {
        startLoading(for: .by)
    }
    
    private func removeIndicator() {
        stopLoading(for: .by)
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

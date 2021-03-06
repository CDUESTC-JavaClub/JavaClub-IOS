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
    @IBOutlet var interactionView: UIView!
    @IBOutlet var usernameContainerView: DesignableView!
    @IBOutlet var passwordContainerView: DesignableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        configureAppearance()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let id = Defaults[.jcUser]?.studentID {
            usernameField.text = "\(id)"
            usernameField.isUserInteractionEnabled = false
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        configureAppearance()
    }
}


extension KABindingViewController {
    
    private func setup() {
        loginBtn.setTitle("", for: .normal)
        loginBtn.layer.cornerRadius = loginBtn.frame.width / 2
        
        usernameField.layer.borderWidth = 1
        usernameField.layer.cornerRadius = usernameField.frame.height / 2
        usernameField.clipsToBounds = true
        usernameField.autocorrectionType = .no
        usernameField.keyboardType = .numberPad
        
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
                        let alert = UIAlertController(title: "??????", message: "???????????????????????????????????????????????????????????????????????????????????????", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    if error == .notLoginJC {
                        let alert = UIAlertController(title: "??????", message: "??????????????????????????????????????????????????????", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    } else if error == .wrongPassword {
                        let alert = UIAlertController(title: "??????", message: "?????????????????????????????????????????????", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "??????", message: "?????????????????????????????????", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "??????", message: "??????????????????????????????????????????????????????".localized(), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func showIndicator() {
        startLoading(for: .jw)
    }
    
    private func removeIndicator() {
        stopLoading(for: .jw)
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

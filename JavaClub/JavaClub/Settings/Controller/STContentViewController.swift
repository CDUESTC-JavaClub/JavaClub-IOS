//
//  STContentViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/26.
//

import UIKit
import Defaults

class STContentViewController: UIViewController {
    @IBOutlet var banner: UIImageView!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var signatureLabel: UILabel!
    @IBOutlet var studentIDLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var useDarkModeSwitch: UISwitch!
    @IBOutlet var useSystemAppearanceSwitch: UISwitch!
    @IBOutlet var checkUpdateBtn: UIButton!
    @IBOutlet var logoutBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
}


// MARK: Actions -
extension STContentViewController {
    
    @IBAction func switchDidToggle(_ sender: UISwitch) {
        switch sender {
        case useDarkModeSwitch:
            Defaults[.useDarkMode] = sender.isOn
            
        case useSystemAppearanceSwitch:
            if sender.isOn {
                useDarkModeSwitch.isOn = true
                useDarkModeSwitch.isEnabled = false
            } else {
                useDarkModeSwitch.isEnabled = true
            }
            Defaults[.useSystemAppearance] = sender.isOn
            
        default:
            break
        }
    }
    
    @IBAction func buttonOnTap(_ sender: UIButton) {
        switch sender {
        case checkUpdateBtn:
            break
            
        case logoutBtn:
            JCLoginState.shared.isLoggedIn = false
            JCLoginState.shared.isBound = false
            
        default:
            break
        }
    }
}


// MARK: Private Methods -
extension STContentViewController {
    
    private func setup() {
        useDarkModeSwitch.addTarget(self, action: #selector(switchDidToggle(_:)), for: .valueChanged)
        useDarkModeSwitch.isOn = Defaults[.useDarkMode]
        useSystemAppearanceSwitch.addTarget(self, action: #selector(switchDidToggle(_:)), for: .valueChanged)
        useSystemAppearanceSwitch.isOn = Defaults[.useSystemAppearance]
        
        checkUpdateBtn.addTarget(self, action: #selector(buttonOnTap(_:)), for: .touchUpInside)
        logoutBtn.addTarget(self, action: #selector(buttonOnTap(_:)), for: .touchUpInside)
        
        if useSystemAppearanceSwitch.isOn {
            useDarkModeSwitch.isOn = true
            useDarkModeSwitch.isEnabled = false
        }
    }
}

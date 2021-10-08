//
//  STContentViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/26.
//

import UIKit
import Defaults
import Kingfisher

class STContentViewController: UIViewController {
    @IBOutlet var banner: UIImageView!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var signatureLabel: UILabel!
    @IBOutlet var studentIDLabel: UILabel!
    @IBOutlet var announcementSection: UIView!
    @IBOutlet var bindingSection: UIView!
    @IBOutlet var optionSection: UIView!
    @IBOutlet var actionSection: UIView!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var useDarkModeSwitch: UISwitch!
    @IBOutlet var useSystemAppearanceSwitch: UISwitch!
    @IBOutlet var checkUpdateItem: TappableItemView!
    @IBOutlet var logoutItem: TappableItemView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let _ = Defaults.observe(.user) { [weak self] obj in
            self?.didUpdateLoginState(obj.newValue)
        }.tieToLifetime(of: self)
        
        let _ = Defaults.observe(.avatarLocal) { [weak self] obj in
            self?.updateUserMedia(avatarURL: obj.newValue, bannerURL: nil)
        }.tieToLifetime(of: self)
        
        let _ = Defaults.observe(.bannerLocal) { [weak self] obj in
            self?.updateUserMedia(avatarURL: nil, bannerURL: obj.newValue)
        }.tieToLifetime(of: self)
        
        setup()
        configureAppearance()
        loadInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        configureAppearance()
    }
}


// MARK: Actions -
extension STContentViewController {
    
    @IBAction func switchDidToggle(_ sender: UISwitch) {
        switch sender {
        case useDarkModeSwitch:
            Defaults[.useDarkMode] = sender.isOn
            if !useSystemAppearanceSwitch.isOn {
                view.window?.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
            }
            
        case useSystemAppearanceSwitch:
            if sender.isOn {
                useDarkModeSwitch.isOn = true
                useDarkModeSwitch.isEnabled = false
                view.window?.overrideUserInterfaceStyle = .unspecified
            } else {
                useDarkModeSwitch.isEnabled = true
                view.window?.overrideUserInterfaceStyle = useDarkModeSwitch.isOn ? .dark : .light
            }
            Defaults[.useSystemAppearance] = sender.isOn
            
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
        
        checkUpdateItem.didTap = {
            
        }
        
        logoutItem.didTap = {
            JCAccountManager.shared.logout()
        }
        
        if useSystemAppearanceSwitch.isOn {
            useDarkModeSwitch.isOn = true
            useDarkModeSwitch.isEnabled = false
        }
        
        avatar.layer.masksToBounds = false
        avatar.layer.cornerRadius = 63
        avatar.clipsToBounds = true
        
    }
    
    private func configureAppearance() {
        if isDarkMode {
            view.backgroundColor = UIColor(hex: "000000")
            announcementSection.backgroundColor = UIColor(hex: "1C1C1E")
            bindingSection.backgroundColor = UIColor(hex: "1C1C1E")
            optionSection.backgroundColor = UIColor(hex: "1C1C1E")
            actionSection.backgroundColor = UIColor(hex: "1C1C1E")
            checkUpdateItem.backgroundColor = UIColor(hex: "1C1C1E")
            checkUpdateItem.normalColor = UIColor(hex: "1C1C1E")
            logoutItem.backgroundColor = UIColor(hex: "1C1C1E")
            logoutItem.normalColor = UIColor(hex: "1C1C1E")
        } else {
            view.backgroundColor = UIColor(hex: "F2F2F7")
            announcementSection.backgroundColor = UIColor(hex: "FFFFFF")
            bindingSection.backgroundColor = UIColor(hex: "FFFFFF")
            optionSection.backgroundColor = UIColor(hex: "FFFFFF")
            actionSection.backgroundColor = UIColor(hex: "FFFFFF")
            checkUpdateItem.backgroundColor = UIColor(hex: "FFFFFF")
            checkUpdateItem.normalColor = UIColor(hex: "FFFFFF")
            logoutItem.backgroundColor = UIColor(hex: "FFFFFF")
            logoutItem.normalColor = UIColor(hex: "FFFFFF")
        }
    }
    
    private func loadInfo() {
        didUpdateLoginState(Defaults[.user])
    }
    
    private func didUpdateLoginState(_ userInfo: JCUser?) {
        if let userInfo = userInfo {
            usernameLabel.text = userInfo.username
            signatureLabel.text = userInfo.signature
            studentIDLabel.text = userInfo.studentID ?? "无"
            emailLabel.text = userInfo.email
            
            if let avatarLocal = Defaults[.avatarLocal], let bannerLocal = Defaults[.bannerLocal] {
                updateUserMedia(avatarURL: avatarLocal, bannerURL: bannerLocal)
            }
        } else {
            usernameLabel.text = "请先登录"
            signatureLabel.text = ""
            studentIDLabel.text = "N/A"
            emailLabel.text = "N/A"
            avatar.image = UIImage.fromColor(.clear)
            banner.image = UIImage.fromColor(.clear)
        }
    }
    
    private func updateUserMedia(avatarURL: URL?, bannerURL: URL?) {
        if let avatarURL = avatarURL {
            avatar.kf.setImage(with: avatarURL, options: [.keepCurrentImageWhileLoading]) { result in
                switch result {
                case .success(_):
                    print("DEBUG: Avatar Retrieved Successfully.")
                    
                default:
                    print("DEBUG: Avatar Retrieved Failed.")
                }
            }
        }
        
        if let bannerURL = bannerURL {
            banner.kf.setImage(with: bannerURL, options: [.keepCurrentImageWhileLoading]) { result in
                switch result {
                case .success(_):
                    print("DEBUG: Banner Retrieved Successfully.")
                    
                default:
                    print("DEBUG: Banner Retrieved Failed.")
                }
            }
        }
    }
}

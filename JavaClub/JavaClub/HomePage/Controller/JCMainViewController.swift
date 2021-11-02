//
//  JCMainViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/26.
//

import UIKit
import Defaults
import DeviceKit

class JCMainViewController: UIViewController {
    private var loginVC: JCLoginViewController!
    private var webVC: JCWebViewController!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let _ = Defaults.observe(.sessionURL) { [weak self] obj in
            self?.didUpdateLoginState()
        }.tieToLifetime(of: self)
    }
}


extension JCMainViewController {
    
    private func didUpdateLoginState() {
        if !JCLoginState.shared.jc {
            loginVC = UIStoryboard(name: "JavaClub", bundle: .main)
                .instantiateViewController(withIdentifier: "JCLoginViewController")
            as? JCLoginViewController
            
            UITabBar.appearance().isHidden = true
            present(loginVC, animated: true) { [self] in
                if webVC != nil {
                    webVC.view.removeFromSuperview()
                    webVC = nil
                }
            }
        } else {
            loginVC = nil
            UITabBar.appearance().isHidden = false
            
            let isSmallScreen = Device.current.isOneOf(Device.smallScreenModels)
            
            if webVC == nil, let sessionURL = Defaults[.sessionURL] {
                let url = !Defaults[.firstLogin] ? JCAccountManager.shared.javaClubURL : sessionURL
                webVC = JCWebViewController(url: url)
                view.addSubview(webVC.view)
                webVC.view.snp.makeConstraints { make in
                    make.top.equalTo(view).inset(isSmallScreen ? 20 : 40)
                    make.leading.trailing.bottom.equalTo(view)
                }
                
                Defaults[.firstLogin] = false
            }
        }
    }
}


extension Device {
    
    static let smallScreenModels: [Device] = [
        .iPhone6s,
        .iPhone6sPlus,
        .iPhone7,
        .iPhone7Plus,
        .iPhone8,
        .iPhone8Plus,
        .iPhoneSE,
        .iPhoneSE2,
        .simulator(.iPhone6s),
        .simulator(.iPhone6sPlus),
        .simulator(.iPhone7),
        .simulator(.iPhone7Plus),
        .simulator(.iPhone8),
        .simulator(.iPhone8Plus),
        .simulator(.iPhoneSE),
        .simulator(.iPhoneSE2),
    ]
}

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
        
        NotificationCenter.default.addObserver(
            forName: .didUpdateJCLoginState,
            object: nil,
            queue: .main,
            using: didUpdateLoginState(_:)
        )
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
        
        didUpdateLoginState(Notification(name: .didUpdateJCLoginState, object: nil, userInfo: nil))
    }
}


extension JCMainViewController {
    
    private func didUpdateLoginState(_ notification: Notification) {
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
            
            let isSmallScreen = Device.current.isOneOf(Device.smallScreenModels)
            
            if webVC == nil, let sessionURL = Defaults[.sessionURL] {
                let url = Defaults[.sessionExpired] ? JCAccountManager.shared.javaClubURL : sessionURL
                webVC = JCWebViewController(url: url)
                view.addSubview(webVC.view)
                webVC.view.snp.makeConstraints { make in
                    make.top.equalTo(view).inset(isSmallScreen ? 20 : 40)
                    make.leading.trailing.bottom.equalTo(view)
                }
                
                Defaults[.sessionExpired] = true
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

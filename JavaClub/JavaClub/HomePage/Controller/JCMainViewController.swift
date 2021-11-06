//
//  JCMainViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/26.
//

import UIKit
import Defaults
import SnapKit

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
        NotificationCenter.default.addObserver(
            forName: .didUpdateJCLoginState,
            object: nil,
            queue: .main,
            using: didUpdateJCLoginState(_:)
        )
        
        let _ = Defaults.observe(.sessionURL) { [weak self] obj in
            self?.didResetJCState(obj.newValue.isNil)
        }.tieToLifetime(of: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !Defaults[.jcLoginInfo].isNil, !JCLoginState.shared.jc {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate?.loginJCIfAvailable()
        } else {
            didResetJCState(Defaults[.sessionURL].isNil)
        }
    }
}


extension JCMainViewController {
    
    private func didUpdateJCLoginState(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [Int: Bool],
            let isLoggedIn = userInfo[0]
        else { return }
        
        if isLoggedIn {
            webVC.view.isHidden = false
            stopLoading(for: .jc)
        }
    }
    
    private func didResetJCState(_ reset: Bool) {
        if reset {
            if !webVC.isNil {
                webVC.view.removeFromSuperview()
                webVC = nil
            }
            
            loginVC = UIStoryboard(name: "JavaClub", bundle: .main)
                .instantiateViewController(withIdentifier: "JCLoginViewController")
            as? JCLoginViewController
            
            addChild(loginVC)
            view.addSubview(loginVC.view)
            loginVC.view.snp.makeConstraints { make in
                make.edges.equalTo(view)
            }
            
            tabBarController?.tabBar.isHidden = true
        } else {
            if !loginVC.isNil {
                loginVC.view.removeFromSuperview()
                loginVC = nil
            }
            
            if webVC == nil, let sessionURL = Defaults[.sessionURL] {
                let url = !Defaults[.firstLogin] ? JCAccountManager.shared.javaClubURL : sessionURL
                webVC = JCWebViewController(url: url)
                view.addSubview(webVC.view)
                webVC.view.snp.makeConstraints { make in
                    make.top.equalTo(view.snp.topMargin)
                    make.leading.trailing.equalTo(view)
                    make.bottom.equalTo(view.snp.bottomMargin)
                }
                
                Defaults[.firstLogin] = false
            }
            
            tabBarController?.tabBar.isHidden = false
            
            if !JCLoginState.shared.jc {
                webVC.view.isHidden = true
                startLoading(for: .jc)
            }
        }
    }
}

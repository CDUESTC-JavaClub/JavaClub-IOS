//
//  JCMainViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/26.
//

import UIKit
import Defaults
import SnapKit
import Reachability

class JCMainViewController: UIViewController {
    private var loginVC: JCLoginViewController!
    private var webVC: JCWebViewController!
    private var refreshVC: JCRefreshViewController!
    
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
        
        let _ = Defaults.observe(.sessionURL, options: []) { [weak self] obj in
            self?.didResetJCState(obj.newValue.isNil)
        }.tieToLifetime(of: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        
        if !Defaults[.jcLoginInfo].isNil, !JCLoginState.shared.jc {
            loginJCIfAvailable { [weak self] success in
                if success {
                    self?.didResetJCState(Defaults[.sessionURL].isNil)
                } else {
                    self?.autoLoginJCFailed()
                }
            }
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
            stopLoading(for: .jc)
            tabBarEnabled(true)
        }
    }
    
    private func didResetJCState(_ reset: Bool) {
        if reset {
            if !webVC.isNil {
                webVC.view.removeFromSuperview()
                webVC = nil
            }
            
            if !refreshVC.isNil {
                refreshVC.view.removeFromSuperview()
                refreshVC = nil
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
            
            if !refreshVC.isNil {
                refreshVC.view.removeFromSuperview()
                refreshVC = nil
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
        }
    }
    
    private func loginJCIfAvailable(_ completion: ((Bool) -> Void)? = nil) {
        startLoading(for: .jc)
        tabBarEnabled(false)
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.loginJCIfAvailable(completion)
    }
    
    private func autoLoginJCFailed() {
        stopLoading(for: .jc)
        tabBarEnabled(false)
        
        if !webVC.isNil {
            webVC.view.removeFromSuperview()
            webVC = nil
        }
        
        if refreshVC.isNil {
            refreshVC =  UIStoryboard(name: "JavaClub", bundle: .main)
                .instantiateViewController(withIdentifier: "JCRefreshViewController")
            as? JCRefreshViewController
            
            refreshVC.onTapGesture = { [weak self] in
                self?.loginJCIfAvailable { success in
                    if success {
                        self?.didResetJCState(Defaults[.sessionURL].isNil)
                    } else {
                        self?.stopLoading(for: .jc)
                    }
                }
            }
            
            view.addSubview(refreshVC.view)
            refreshVC.view.snp.makeConstraints { make in
                make.edges.equalTo(view)
            }
        }
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
}

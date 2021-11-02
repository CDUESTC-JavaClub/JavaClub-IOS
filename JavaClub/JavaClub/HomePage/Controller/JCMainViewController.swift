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
            if webVC != nil {
                webVC = nil
            }
            
            loginVC = UIStoryboard(name: "JavaClub", bundle: .main)
                .instantiateViewController(withIdentifier: "JCLoginViewController")
            as? JCLoginViewController
            
            view.addSubview(loginVC.view)
            loginVC.view.snp.makeConstraints { make in
                make.edges.equalTo(view)
            }
            
            tabBarController?.tabBar.isHidden = true
        } else {
            if loginVC != nil {
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
        }
    }
}

//
//  JCMainViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/26.
//

import UIKit

class JCMainViewController: UIViewController {
    private let loginVC: JCLoginViewController!
    private var webVC: JCWebViewController!
    private let url = URL(string: "https://royrao.me/")!
    
    
    init() {
        loginVC = UIStoryboard(name: "JavaClub", bundle: .main)
            .instantiateViewController(withIdentifier: "JCLoginViewController")
        as? JCLoginViewController
        
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(
            forName: .didUpdateLoginState,
            object: nil,
            queue: .main,
            using: didUpdateLoginState(_:)
        )
        
        NotificationCenter.default.addObserver(
            forName: .didUpdateBindingState,
            object: nil,
            queue: .main,
            using: didUpdateBindingState(_:)
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
        
        didUpdateLoginState(Notification(name: .didUpdateLoginState, object: nil, userInfo: nil))
    }
}


extension JCMainViewController {
    
    private func didUpdateLoginState(_ notification: Notification) {
        if !JCLoginState.shared.isLoggedIn {
            UITabBar.appearance().isHidden = true
            present(loginVC, animated: true) { [self] in
                if webVC != nil {
                    webVC.view.removeFromSuperview()
                    webVC = nil
                }
            }
        } else {
            if webVC == nil {
                webVC = JCWebViewController(url: url)
                view.addSubview(webVC.view)
                webVC.view.snp.makeConstraints { make in
                    make.edges.equalTo(view)
                }
            }
        }
    }
    
    private func didUpdateBindingState(_ notification: Notification) {
        
    }
}

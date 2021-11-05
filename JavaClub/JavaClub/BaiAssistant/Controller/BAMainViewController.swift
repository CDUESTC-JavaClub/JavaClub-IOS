//
//  BAMainViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/11/1.
//

import UIKit
import Defaults

class BAMainViewController: UIViewController {
    private var loginVC: BALoginViewController!
    private var contentVC: BAContentViewController!
    
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
            forName: .didUpdateBYLoginState,
            object: nil,
            queue: .main,
            using: didUpdateBYLoginState(_:)
        )
        
        let _ = Defaults.observe(.byAccount) { [weak self] obj in
            self?.didResetBYState(obj.newValue.isNil)
        }.tieToLifetime(of: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !Defaults[.byLoginInfo].isNil {
            loginBYIfAvailable()
        } else {
            didResetBYState(Defaults[.byAccount].isNil)
        }
    }
}


// MARK: Private Methods -
extension BAMainViewController {
    
    private func didUpdateBYLoginState(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [Int: Bool],
            let isLoggedIn = userInfo[0]
        else { return }
        
        if isLoggedIn {
            contentVC.view.isHidden = false
            stopLoading(for: .by)
        }
    }
    
    private func didResetBYState(_ reset: Bool) {
        if reset {
            if !contentVC.isNil {
                contentVC.view.removeFromSuperview()
                contentVC = nil
            }
            
            loginVC = UIStoryboard(name: "BaiAssistant", bundle: .main)
                .instantiateViewController(withIdentifier: "BALoginViewController")
            as? BALoginViewController
            
            addChild(loginVC)
            view.addSubview(loginVC.view)
            loginVC.view.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(view)
                make.bottom.equalTo(view.snp.bottomMargin)
            }
        } else {
            if !loginVC.isNil {
                loginVC.view.removeFromSuperview()
                loginVC = nil
            }
            
            contentVC = UIStoryboard(name: "BaiAssistant", bundle: .main)
                .instantiateViewController(withIdentifier: "BAContentViewController")
            as? BAContentViewController
            
            addChild(contentVC)
            view.addSubview(contentVC.view)
            contentVC.view.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(view)
                make.bottom.equalTo(view.snp.bottomMargin)
            }
            
            if !JCLoginState.shared.by {
                contentVC.view.isHidden = true
                startLoading(for: .by)
            }
        }
    }
    
    func loginBYIfAvailable() {
        
    }
}

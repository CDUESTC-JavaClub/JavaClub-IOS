//
//  KAMainViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/10/8.
//

import UIKit
import Defaults
import SnapKit

class KAMainViewController: UIViewController {
    private var contentVC: KAContentViewController!
    private var bindingVC: KABindingViewController!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(
            forName: .didUpdateJWLoginState,
            object: nil,
            queue: .main,
            using: didUpdateJWLoginState(_:)
        )
        
        let _ = Defaults.observe(.enrollment, options: []) { [weak self] obj in
            self?.didResetJWState(obj.newValue.isNil)
        }.tieToLifetime(of: self)
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
        
        if !Defaults[.jwLoginInfo].isNil {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            delegate?.loginJWIfAvailable()
        } else {
            didResetJWState(Defaults[.enrollment].isNil)
        }
    }
}


// MARK: Private Methods -
extension KAMainViewController {
    
    private func didUpdateJWLoginState(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [Int: Bool],
            let isLoggedIn = userInfo[0]
        else { return }
        
        #warning("需要先跑一遍，否则contentVC为空")
        #warning("Defaults.observe可能未被调用")
        if isLoggedIn {
            contentVC.view.isHidden = false
            stopLoading()
        }
    }
    
    private func didResetJWState(_ reset: Bool) {
        if reset {
            if !contentVC.isNil {
                contentVC.view.removeFromSuperview()
                contentVC = nil
            }
            
            bindingVC = UIStoryboard(name: "KcAssistant", bundle: .main)
                .instantiateViewController(withIdentifier: "KABindingViewController")
            as? KABindingViewController
            
            addChild(bindingVC)
            view.addSubview(bindingVC.view)
            bindingVC.view.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(view)
                make.bottom.equalTo(view.snp.bottomMargin)
            }
        } else {
            if !bindingVC.isNil {
                bindingVC.view.removeFromSuperview()
                bindingVC = nil
            }
            
            contentVC = UIStoryboard(name: "KcAssistant", bundle: .main)
                .instantiateViewController(withIdentifier: "KAContentViewController")
            as? KAContentViewController
            
            addChild(contentVC)
            view.addSubview(contentVC.view)
            contentVC.view.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(view)
                make.bottom.equalTo(view.snp.bottomMargin)
            }
            
            if !JCLoginState.shared.jw {
                contentVC.view.isHidden = true
                startLoading()
            }
        }
    }
}

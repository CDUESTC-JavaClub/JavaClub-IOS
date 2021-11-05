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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            forName: .didUpdateJWLoginState,
            object: nil,
            queue: .main,
            using: didUpdateJWLoginState(_:)
        )
        
        let _ = Defaults.observe(.enrollment) { [weak self] obj in
            self?.didResetJWState(obj.newValue.isNil)
        }.tieToLifetime(of: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !Defaults[.jwLoginInfo].isNil, !JCLoginState.shared.jw {
            loginJWIfAvailable()
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
        
        if isLoggedIn {
            contentVC.view.isHidden = false
            stopLoading(for: .jw)
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
                startLoading(for: .jw)
            }
        }
    }
    
    func loginJWIfAvailable() {
        if let jwInfo = Defaults[.jwLoginInfo], let user = Defaults[.jcUser] {
            JCAccountManager.shared.loginJW(info: jwInfo, bind: user.studentID == nil) { result in
                
                switch result {
                case .success(let success):
                    if success {
                        JCAccountManager.shared.getEnrollmentInfo { result in
                            
                            switch result {
                            case .success(let enr):
                                Defaults[.enrollment] = enr
                                JCLoginState.shared.jw = true
                                print("DEBUG: Auto Login JW Succeeded.")
                                
                            case .failure(let error):
                                if error == .notLoginJC {
                                    print("DEBUG: Please Login JC First.")
                                } else {
                                    print("DEBUG: Fetch Enrollment Info Failed With Error: \(String(describing: error))")
                                }
                            }
                            
                        }
                    } else {
                        print("DEBUG: Auto Login JW Failed. (Maybe Wrong Username Or Password)")
                    }
                    
                case .failure(let error):
                    print("DEBUG: Auto Login JW Failed With Error: \(String(describing: error)).")
                }
            }
        } else {
            print("DEBUG: JW Credential Lost.")
        }
    }
}

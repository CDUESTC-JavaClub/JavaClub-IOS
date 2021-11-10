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
            forName: .didUpdateJWLoginState,
            object: nil,
            queue: .main,
            using: didUpdateJWLoginState(_:)
        )
        
        let _ = Defaults.observe(.enrollment) { [weak self] obj in
            self?.didResetJWState(obj.newValue.isNil)
        }.tieToLifetime(of: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !Defaults[.jwLoginInfo].isNil, !JCLoginState.shared.jw {
            loginJWIfAvailable { [weak self] success in
                if success {
                    self?.didResetJWState(Defaults[.enrollment].isNil)
                } else {
                    self?.autoLoginJWFailed()
                }
            }
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
            stopLoading(for: .jw)
            tabBarEnabled(true)
            
            if !contentVC.isNil {
                contentVC.view.isHidden = false
            }
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
            
            contentVC.view.isHidden = true
            
            addChild(contentVC)
            view.addSubview(contentVC.view)
            contentVC.view.snp.makeConstraints { make in
                make.top.leading.trailing.equalTo(view)
                make.bottom.equalTo(view.snp.bottomMargin)
            }
        }
    }
    
    func loginJWIfAvailable(_ completion: ((Bool) -> Void)? = nil) {
        startLoading(for: .jw)
        
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
                                completion?(true)
                                
                            case .failure(let error):
                                if error == .notLoginJC {
                                    print("DEBUG: Please Login JC First.")
                                } else {
                                    print("DEBUG: Fetch Enrollment Info Failed With Error: \(String(describing: error))")
                                }
                                completion?(false)
                            }
                            
                        }
                    } else {
                        print("DEBUG: Auto Login JW Failed. (Maybe Wrong Username Or Password)")
                        completion?(false)
                    }
                    
                case .failure(let error):
                    print("DEBUG: Auto Login JW Failed With Error: \(String(describing: error)).")
                    completion?(false)
                }
            }
        } else {
            print("DEBUG: JW Credential Lost.")
            completion?(false)
        }
    }
    
    private func autoLoginJWFailed() {
        stopLoading(for: .jw)
        tabBarEnabled(false)
        
        if !contentVC.isNil {
            contentVC.view.removeFromSuperview()
            contentVC = nil
        }
        
        if refreshVC.isNil {
            refreshVC =  UIStoryboard(name: "JavaClub", bundle: .main)
                .instantiateViewController(withIdentifier: "JCRefreshViewController")
            as? JCRefreshViewController
            
            refreshVC.onTapGesture = { [weak self] in
                self?.loginJWIfAvailable { success in
                    if success {
                        self?.didResetJWState(Defaults[.enrollment].isNil)
                    } else {
                        self?.stopLoading(for: .jw)
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

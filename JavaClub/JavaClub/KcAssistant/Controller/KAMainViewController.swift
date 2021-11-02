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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let _ = Defaults.observe(.enrollment) { [weak self] _ in
            self?.didUpdateLoginState()
        }.tieToLifetime(of: self)
    }
}


// MARK: Private Methods -
extension KAMainViewController {
    
    private func didUpdateLoginState() {
        if !JCLoginState.shared.jw {
            if !contentVC.isNil {
                contentVC.view.removeFromSuperview()
                contentVC = nil
            }
            
            bindingVC = UIStoryboard(name: "KcAssistant", bundle: .main)
                .instantiateViewController(withIdentifier: "KABindingViewController")
            as? KABindingViewController
            
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
        }
    }
}

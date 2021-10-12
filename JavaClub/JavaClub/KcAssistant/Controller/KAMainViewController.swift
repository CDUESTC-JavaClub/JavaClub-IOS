//
//  KAMainViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/10/8.
//

import UIKit

class KAMainViewController: UIViewController {
    private var contentVC: KAContentViewController!
    private var bindingVC: KABindingViewController!
    
    init() {
        contentVC = UIStoryboard(name: "KcAssistant", bundle: .main)
            .instantiateViewController(withIdentifier: "KAContentViewController")
        as? KAContentViewController
        
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(
            forName: .didUpdateJWLoginState,
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
        addChild(contentVC)
        view.addSubview(contentVC.view)
        contentVC.view.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        didUpdateLoginState(Notification(name: .didUpdateJWLoginState, object: nil, userInfo: nil))
    }
}


// MARK: Private Methods -
extension KAMainViewController {
    
    private func didUpdateLoginState(_ notification: Notification) {
        if !JCLoginState.shared.jw {
            bindingVC = UIStoryboard(name: "KcAssistant", bundle: .main)
                .instantiateViewController(withIdentifier: "KABindingViewController")
            as? KABindingViewController
            
            UITabBar.appearance().isHidden = true
            present(bindingVC, animated: true) { [self] in
                contentVC.view.isHidden = true
            }
        } else {
            if bindingVC != nil {
                bindingVC = nil
            }

            contentVC.view.isHidden = false
        }
    }
}

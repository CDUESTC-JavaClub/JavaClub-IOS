//
//  BAMainViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/11/1.
//

import UIKit

class BAMainViewController: UIViewController {
    private var contentVC: BAContentViewController!

    init() {
        contentVC = UIStoryboard(name: "BaiAssistant", bundle: .main)
            .instantiateViewController(withIdentifier: "BAContentViewController")
        as? BAContentViewController
        
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
extension BAMainViewController {
    
    private func didUpdateLoginState(_ notification: Notification) {
        
    }
}

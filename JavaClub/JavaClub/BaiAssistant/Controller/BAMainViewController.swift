//
//  BAMainViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/11/1.
//

import UIKit
import Defaults

class BAMainViewController: UIViewController {
    private var contentVC: BAContentViewController!

    init() {
        contentVC = UIStoryboard(name: "BaiAssistant", bundle: .main)
            .instantiateViewController(withIdentifier: "BAContentViewController")
        as? BAContentViewController
        
        super.init(nibName: nil, bundle: nil)
        
        let _ = Defaults.observe(.byAccount) { [weak self] obj in
            self?.didUpdateLoginState(account: obj.newValue)
        }.tieToLifetime(of: self)
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
        
        didUpdateLoginState(account: Defaults[.byAccount])
    }
}


// MARK: Private Methods -
extension BAMainViewController {
    
    private func didUpdateLoginState(account: BAAccount?) {
        
    }
}

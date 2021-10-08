//
//  KAMainViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/10/8.
//

import UIKit

class KAMainViewController: UIViewController {
    private let contentVC: KAContentViewController!
    
    init() {
        contentVC = UIStoryboard(name: "KcAssistant", bundle: .main)
            .instantiateViewController(withIdentifier: "KAContentViewController")
        as? KAContentViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(contentVC.view)
        contentVC.view.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}

//
//  STMainViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/26.
//

import UIKit
import SnapKit
import Defaults

class STMainViewController: UIViewController {
    private let contentVC: STContentViewController!
    private var lastRefreshTime = Date()
    
    init() {
        contentVC = UIStoryboard(name: "Settings", bundle: .main)
            .instantiateViewController(withIdentifier: "STContentViewController")
        as? STContentViewController
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        refresh()
    }
    
    
    private func refresh() {
        // Check Refresh Rate (3 min)
        if Date().timeIntervalSince(lastRefreshTime) < 180 {
            print("DEBUG: Not Enough Time For Next Refresh.")
            return
        } else {
            lastRefreshTime = Date()
        }
        
        contentVC.updateAvatar(Defaults[.avatarURL])
        contentVC.updateBanner(Defaults[.bannerURL])
    }
}

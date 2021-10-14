//
//  JCTabBarController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/24.
//

import UIKit
import SwiftUI

class JCTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        tabBar.tintColor = UIColor(hex: "60d1ae")
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        setupVCs()
    }
}


// MARK: Private Methods -
extension JCTabBarController {
    
    private func setupVCs() {
//        let baVC = UIHostingController(rootView: BAContentView())
        
        viewControllers = [
            createNavController(for: JCMainViewController(), title: "JavaClub", image: UIImage(named: "nav_home")!),
            createNavController(for: KAMainViewController(), title: "教务", image: UIImage(named: "nav_kc")!, swipEnabled: false),
//            createNavController(for: baVC, title: "百叶计划", image: UIImage(named: "nav_bai")!),
            createNavController(for: STMainViewController(), title: "设置", image: UIImage(named: "nav_settings")!),
        ]
    }
    
    private func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage,
        swipEnabled: Bool = true
    ) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.isNavigationBarHidden = true
        navController.interactivePopGestureRecognizer?.isEnabled = swipEnabled
        
        return navController
    }
}

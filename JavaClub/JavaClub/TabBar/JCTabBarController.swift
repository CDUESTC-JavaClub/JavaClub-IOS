//
//  JCTabBarController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/24.
//

import UIKit
import SwiftUI

class JCTabBarController: UITabBarController {
    
    override var shouldAutorotate: Bool { false }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { .portrait }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        tabBar.tintColor = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.tintColor
        tabBar.standardAppearance = appearance
        tabBar.isTranslucent = false
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        setupVCs()
    }
}


// MARK: Private Methods -
extension JCTabBarController {
    
    private func setupVCs() {
        viewControllers = [
            createNavController(for: JCMainViewController(), title: "JavaClub", image: UIImage(named: "nav_home")!),
            createNavController(for: KAMainViewController(), title: "教务".localized(), image: UIImage(named: "nav_kc")!, navBarHidden: false),
            createNavController(for: BAMainViewController(), title: "百叶计划".localized(), image: UIImage(named: "nav_bai")!, navBarHidden: false),
            createNavController(for: STMainViewController(), title: "设置".localized(), image: UIImage(named: "nav_settings")!),
        ]
    }
    
    private func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage,
        navBarHidden: Bool = true,
        swipEnabled: Bool = true
    ) -> UINavigationController {
        let navController = NoRotateNavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.isNavigationBarHidden = navBarHidden
        navController.interactivePopGestureRecognizer?.isEnabled = swipEnabled
        
        return navController
    }
}

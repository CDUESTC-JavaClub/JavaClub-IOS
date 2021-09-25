//
//  JCTabBarController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/24.
//

import UIKit

class JCTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        tabBar.tintColor = .label
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
        let url = URL(string: "https://royrao.me/")!
        
        viewControllers = [
            createNavController(for: JCWebViewController(url: url), title: "JavaClub", image: UIImage(systemName: "house")!),
            createNavController(for: KAViewController(), title: "教务", image: UIImage(systemName: "square.and.pencil")!),
            createNavController(for: BAViewController(), title: "百叶计划", image: UIImage(systemName: "chart.pie")!),
            createNavController(for: STViewController(), title: "设置", image: UIImage(systemName: "gear")!),
        ]
    }
    
    private func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage
    ) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.isNavigationBarHidden = true
        
        return navController
    }
}

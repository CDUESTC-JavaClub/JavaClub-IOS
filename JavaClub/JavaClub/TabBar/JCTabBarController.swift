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
        tabBar.barTintColor = .systemBackground
        tabBar.tintColor = .label
        UITabBar.appearance().isHidden = true
        
        setupVCs()
    }
}


// MARK: Private Methods -
extension JCTabBarController {
    
    private func setupVCs() {
        let loginVC = UIStoryboard(name: "JavaClub", bundle: .main)
            .instantiateViewController(withIdentifier: "JCLoginViewController")
        as! JCLoginViewController
        
        viewControllers = [
            createNavController(for: loginVC, title: "JavaClub", image: UIImage(systemName: "house")!),
            createNavController(for: KAViewController(), title: "教务", image: UIImage(systemName: "square.and.pencil")!),
            createNavController(for: KAViewController(), title: "百叶计划", image: UIImage(systemName: "chart.pie")!),
            createNavController(for: KAViewController(), title: "设置", image: UIImage(systemName: "gear")!),
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

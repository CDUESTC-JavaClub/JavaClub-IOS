//
//  JCTabBarController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/24.
//

import UIKit

class JCTabBarController: UITabBarController {
    
}


// MARK: Private Methods -
extension JCTabBarController {
    
    private func setupVCs() {
        
    }
    
    private func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage
    ) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        
        return navController
    }
}

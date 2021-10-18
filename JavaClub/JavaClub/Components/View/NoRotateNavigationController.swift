//
//  NoRotateNavigationController.swift
//  JavaClub
//
//  Created by Roy on 2021/10/18.
//

import UIKit

class NoRotateNavigationController: UINavigationController {
    
    override var shouldAutorotate: Bool { false }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { .portrait }
}

//
//  BAContentViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/11/1.
//

import UIKit

class BAContentViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var infoView: DesignableView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var classLabel: UILabel!
    @IBOutlet var secondaryIdentityLabel: UILabel!
    @IBOutlet var totalScoreLabel: UILabel!
    @IBOutlet var statusHintLabel: UILabel!
    @IBOutlet var bxScoreLabel: UILabel!
    @IBOutlet var jmScoreLabel: UILabel!
    @IBOutlet var dxScoreLabel: UILabel!
    @IBOutlet var mdScoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        configureAppearance()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        configureAppearance()
    }
}


// MARK: Private Methods -
extension BAContentViewController {
    
    private func setup() {
        
    }
    
    private func configureAppearance() {
        if isDarkMode {
            scrollView.backgroundColor = UIColor(hex: "000000")
        } else {
            scrollView.backgroundColor = UIColor(hex: "F2F2F7")
        }
        
        infoView.isDark = isDarkMode
    }
}

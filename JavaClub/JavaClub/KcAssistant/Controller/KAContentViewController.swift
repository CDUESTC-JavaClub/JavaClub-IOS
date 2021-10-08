//
//  KAContentViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/10/8.
//

import UIKit

class KAContentViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var gradeLabel: UILabel!
    @IBOutlet var studentIDLabel: UILabel!
    @IBOutlet var deptLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
}


extension KAContentViewController {
    
    private func setup() {
        scrollView.alwaysBounceVertical = true
    }
}

//
//  BAEventDetailViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/11/10.
//

import UIKit

class BAEventDetailViewController: UIViewController {
    @IBOutlet var eventImgView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var peopleCountLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
}


extension BAEventDetailViewController {
    
    func initialize(with event: BAEvent?) {
        eventImgView.image
    }
}

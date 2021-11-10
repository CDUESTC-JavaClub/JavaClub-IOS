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
    @IBOutlet var applyBtn: LocalizableButton!
    @IBOutlet var cancelbTN: LocalizableButton!
    
    var eventItem: BAEvent?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let eventItem = eventItem {
            initialize(with: eventItem)
        }
    }
}


extension BAEventDetailViewController {
    
    private func initialize(with event: BAEvent?) {
        guard let event = event else { return }

        JCImageManager.shared.fetch(from: event.coverUrl) { [weak self] result in
            DispatchQueue.main.async {
                self?.eventImgView.image = result?.image ?? UIImage(named: "login_bg")
            }
        }
        titleLabel.text = event.eventName
        dateLabel.text = event.startDate.formatted()
        locationLabel.text = event.place
        peopleCountLabel.text = "\(event.regCount)/\(event.maxCount)"
        statusLabel.text = selectStatus(for: event.status)
//        BAAccountManager.shared.eventDetails(for: event.eventID) { [weak self] result in
//            DispatchQueue.main.async {
//                self?.descriptionLabel.text = try? result.get()
//            }
//        }
        descriptionLabel.text = "This is the description."
    }
    
    @IBAction private func applyDidClick(_ sender: UIButton) {
        
    }
    
    @IBAction private func cancelDidClick(_ sender: UIButton) {
        view.removeFromSuperview()
        
    }
    
    private func selectStatus(for status: Int) -> String {
        
        switch status {
            case 4:
                return "报名中"
            
            case 5:
                return "报名结束"
            
            case 7:
                return "活动中"
                
            case 8:
                return "已结束"
            
            default:
                return "未知"
        }
    }
}

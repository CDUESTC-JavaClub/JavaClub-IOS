//
//  KAContentViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/10/8.
//

import UIKit
import Defaults

class KAContentViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var gradeLabel: UILabel!
    @IBOutlet var studentIDLabel: UILabel!
    @IBOutlet var deptLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let _ = Defaults.observe(.enrollment) { [weak self] obj in
            self?.didUpdateEnrollmentState(obj.newValue)
        }.tieToLifetime(of: self)
        
        setup()
        loadInfo()
    }
}


// MARK: Private Methods -
extension KAContentViewController {
    
    private func setup() {
        scrollView.alwaysBounceVertical = true
    }
    
    private func loadInfo() {
        didUpdateEnrollmentState(Defaults[.enrollment])
    }
    
    private func didUpdateEnrollmentState(_ enrollment: KAEnrollment?) {
        if let enrollment = enrollment {
            nameLabel.text = enrollment.name
            gradeLabel.text = "\(enrollment.grade)级 \(enrollment.direction)"
            studentIDLabel.text = "学号：\(enrollment.studentID)"
            deptLabel.text = "院系：\(enrollment.department)（\(enrollment.degree)）"
        } else {
            nameLabel.text = "N/A"
            gradeLabel.text = ""
            studentIDLabel.text = ""
            deptLabel.text = ""
        }
    }
}

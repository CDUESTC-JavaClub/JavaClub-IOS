//
//  KAContentViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/10/8.
//

import UIKit
import Defaults
import SwiftUI

class KAContentViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var infoView: DesignableView!
    @IBOutlet var announcementView: DesignableView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var gradeLabel: UILabel!
    @IBOutlet var studentIDLabel: UILabel!
    @IBOutlet var deptLabel: UILabel!
    
    private var models: [TVSection] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let _ = Defaults.observe(.enrollment) { [weak self] obj in
            self?.didRefreshEnrollmentInfo(obj.newValue)
        }.tieToLifetime(of: self)
        
        setup()
        configureAppearance()
        configureModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        configureAppearance()
    }
}


// MARK: Private Methods -
extension KAContentViewController {
    
    private func setup() {
        tableView.register(TappableViewCell.self, forCellReuseIdentifier: TappableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        // Set Inset For 20 Temporarily
        tableView.contentInset = .init(top: -30, left: 0, bottom: 20, right: 0)
        
        // Disable Scrolling Temporarily
        scrollView.isScrollEnabled = false
        scrollView.alwaysBounceVertical = true
        tableView.alwaysBounceVertical = false
    }
    
    private func configureAppearance() {
        if isDarkMode {
            scrollView.backgroundColor = UIColor(hex: "151515")
            tableView.backgroundColor = UIColor(hex: "151515")
        } else {
            scrollView.backgroundColor = UIColor(hex: "F2F2F7")
        }
        
        infoView.isDark = isDarkMode
        announcementView.isDark = isDarkMode
    }
    
    private func configureModels() {
        models = [
            TVSection(title: "", options: [
                .tappable(model: TVTappableOption(title: "学期成绩查询".localized(), icon: UIImage(named: "score_icon"), handler: { [weak self] in
                    self?.navigationController?.isNavigationBarHidden = false
                    self?.navigationController?.pushViewController(KAScoreViewController(), animated: true)
                })),
                .tappable(model: TVTappableOption(title: "课程表查询".localized(), icon: UIImage(named: "classtable_icon"), handler: { [weak self] in
                    let classTableVC = UIHostingController(rootView: KAClassTableContentview())
                    self?.navigationController?.isNavigationBarHidden = false
                    self?.navigationController?.pushViewController(classTableVC, animated: true)
                })),
                .tappable(model: TVTappableOption(title: "学籍信息查询".localized(), icon: UIImage(named: "enrollment_icon"), handler: { [weak self] in
                    self?.navigationController?.isNavigationBarHidden = false
                    
                    let enrollmentVC = UIStoryboard(name: "KcAssistant", bundle: .main)
                        .instantiateViewController(withIdentifier: "KAEnrollmentViewController")
                    as! KAEnrollmentViewController
                    self?.navigationController?.pushViewController(enrollmentVC, animated: true)
                })),
            ]),
        ]
        
        tableView.reloadData()
    }
    
    private func didRefreshEnrollmentInfo(_ enrollment: KAEnrollment?) {
        if let enrollment = enrollment {
            nameLabel.text = enrollment.name
            gradeLabel.text = "\(enrollment.grade)级 \(enrollment.direction)".localized()
            studentIDLabel.text = "学号：\(enrollment.studentID)".localized()
            deptLabel.text = "院系：\(enrollment.department)（\(enrollment.degree)）".localized()
        } else {
            nameLabel.text = "N/A"
            gradeLabel.text = ""
            studentIDLabel.text = ""
            deptLabel.text = ""
            
            JCAccountManager.shared.getEnrollmentInfo { result in
                if let enr = try? result.get() {
                    Defaults[.enrollment] = enr
                }
            }
        }
    }
}


// MARK: TableView Delegate
extension KAContentViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let type = models[indexPath.section].options[indexPath.row]
        
        switch type {
        case .tappable(let model):
            model.handler()
            
        default:
            break
        }
    }
}


// MARK: TableView DataSource
extension KAContentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = models[indexPath.section].options[indexPath.row]
        
        switch type {
        case .tappable(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TappableViewCell.identifier,
                for: indexPath
            ) as? TappableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model, type: .disclosureIndicator)
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        
        return section.title
    }
}

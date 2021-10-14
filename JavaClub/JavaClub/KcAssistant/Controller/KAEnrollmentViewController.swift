//
//  KAEnrollmentViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/10/14.
//

import UIKit
import SwiftUI

class KAEnrollmentViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var gradeLabel: UILabel!
    @IBOutlet var campusLabel: UILabel!
    @IBOutlet var systemLabel: UILabel!
    @IBOutlet var titleView: DesignableView!
    
    private let indicatorView = _UIHostingView(rootView: LoadingIndicatorView())
    private let refreshControl = UIRefreshControl()
    
    private var models: [TVSection] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refreshControl.addTarget(
            self,
            action: #selector(didRefresh),
            for: .valueChanged
        )
        
        setup()
        configureAppearance()
        didRefresh()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        configureAppearance()
    }
}


extension KAEnrollmentViewController {
    
    private func setup() {
        tableView.register(StaticTableViewCell.self, forCellReuseIdentifier: StaticTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        // Set Inset For 20 Temporarily
        tableView.contentInset = .init(top: 10, left: 0, bottom: 20, right: 0)
    }
    
    private func configureAppearance() {
        if isDarkMode {
            view.backgroundColor = UIColor(hex: "000000")
        } else {
            view.backgroundColor = UIColor(hex: "F2F2F7")
        }
        
        titleView.isDark = isDarkMode
    }
    
    private func configureModels(with info: KAEnrollment) {
        guard let infoDict = info.toDict else { return }
        
        nameLabel.text = info.name
        gradeLabel.text = "\(info.grade)级 \(info.department)"
        campusLabel.text = info.campus
        systemLabel.text = "\(info.enrollmentForm) (\(info.enrollmentStatus))"
        
        let icon = UIImage(systemName: "rosette")
        var options: [TVOptionType] = []
        
        for (_key, _value) in infoDict {
            
            if var _value = _value as? String {
                var localizedTitle: String?
                
                switch _key {
                case "campus":
                    localizedTitle = "所属校区"
                    
                case "degree":
                    localizedTitle = "学历层次"
                    
                case "system":
                    localizedTitle = "学制"
                    
                case "dateEnrolled":
                    localizedTitle = "入学日期"
                    
                    let index = _value.index(_value.startIndex, offsetBy: 9)
                    _value = String(_value.prefix(through: index))
                    
                case "dateGraduation":
                    localizedTitle = "毕业日期"
                    
                    let index = _value.index(_value.startIndex, offsetBy: 9)
                    _value = String(_value.prefix(through: index))
                    
                case "department":
                    localizedTitle = "院系"
                    
                case "subject":
                    localizedTitle = "专业"
                    
                case "grade":
                    localizedTitle = "年级"
                    
                case "direction":
                    localizedTitle = "方向"
                    
                case "_class":
                    localizedTitle = "所属班级"
                    
                case "enrollmentForm":
                    localizedTitle = "学籍形式"
                    
                case "enrollmentStatus":
                    localizedTitle = "学籍状态"
                    
                case "name":
                    localizedTitle = "姓名"
                    
                case "engName":
                    localizedTitle = "英文名"
                    
                case "gender":
                    localizedTitle = "性别"
                    
                case "studentID":
                    localizedTitle = "学号"
                    
                default:
                    break
                }
                
                let opt: TVOptionType = ._static(model: TVStaticOption(title: localizedTitle ?? _key, icon: icon, value: _value))
                options.append(opt)
            }
        }
        
        models = [TVSection(title: "详细信息", options: options)]
        
        tableView.reloadData()
    }
    
    @objc private func didRefresh() {
        showIndicator()
        
        JCAccountManager.shared.getEnrollmentInfo { [weak self] result in
            switch result {
            case .success(let info):
                self?.configureModels(with: info)
                self?.removeIndicator()
                
            case .failure(let error):
                if error == .notLoginJW {
                    print("DEBUG: Used JW Before Login.")
                } else {
                    print("DEBUG: Refresh Enrollment Info With Error: \(String(describing: error))")
                }
                self?.removeIndicator()
            }
        }
        
        refreshControl.endRefreshing()
    }
    
    private func showIndicator() {
        view.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
    }
    
    private func removeIndicator() {
        indicatorView.snp.removeConstraints()
        
        indicatorView.removeFromSuperview()
    }
}


// MARK: TableView Delegate
extension KAEnrollmentViewController: UITableViewDelegate {
    
}


// MARK: TableView DataSource
extension KAEnrollmentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = models[indexPath.section].options[indexPath.row]
        
        switch type {
        case ._static(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StaticTableViewCell.identifier,
                for: indexPath
            ) as? StaticTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model)
            
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

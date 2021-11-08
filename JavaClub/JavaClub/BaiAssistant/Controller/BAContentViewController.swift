//
//  BAContentViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/11/1.
//

import UIKit
import Defaults

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
    
    private var models: [TVSection] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let _ = Defaults.observe(.byAccount) { [weak self] obj in
            self?.didRefreshBYAccount(obj.newValue)
        }.tieToLifetime(of: self)
        
        setup()
        configureAppearance()
        configureModels()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        configureAppearance()
    }
}


// MARK: Private Methods -
extension BAContentViewController {
    
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
            tableView.backgroundColor = UIColor(hex: "F2F2F7")
        }
        
        infoView.isDark = isDarkMode
    }
    
    private func configureModels() {
        models = [
            TVSection(title: "", options: [
                .tappable(model: TVTappableOption(title: "所有活动".localized(), icon: UIImage(named: "all_events_icon"), handler: { [weak self] in
                    self?.navigationController?.isNavigationBarHidden = false
                    self?.navigationController?.pushViewController(BAAllEventsViewController(), animated: true)
                })),
                .tappable(model: TVTappableOption(title: "我的活动".localized(), icon: UIImage(named: "my_events_icon"), handler: { [weak self] in
                    
                })),
                .tappable(model: TVTappableOption(title: "百叶积分".localized(), icon: UIImage(named: "credits_icon"), handler: { [weak self] in
                    
                })),
            ]),
        ]
        
        tableView.reloadData()
    }
    
    private func didRefreshBYAccount(_ byAccount: BAAccount?) {
        if let byAccount = byAccount {
            usernameLabel.text = byAccount.userName
            classLabel.text = byAccount._class
            secondaryIdentityLabel.text = byAccount.identity
            
        } else {
            usernameLabel.text = "N/A"
            classLabel.text = ""
            secondaryIdentityLabel.text = ""
            
            if let loginInfo = Defaults[.byLoginInfo] {
                BAAccountManager.shared.login(info: loginInfo) { result in
                    if let account = try? result.get() {
                        Defaults[.byAccount] = account
                    } else {
                        print("DEBUG: Refresh BY Info Failed.")
                    }
                }
            }
        }
        
//        BAAccountManager.shared.getScore { [weak self] result in
//            DispatchQueue.main.async {
//                if let byScore = try? result.get() {
//                    self?.totalScoreLabel.text = "\(byScore.all)"
//                    self?.bxScoreLabel.text = "\(byScore.bx)"
//                    self?.jmScoreLabel.text = "\(byScore.jm)"
//                    self?.dxScoreLabel.text = "\(byScore.dx)"
//                    self?.mdScoreLabel.text = "\(byScore.md)"
//
//                    if byScore.bx >= 10 && byScore.jm >= 30 && byScore.dx >= 10 && byScore.md >= 10 {
//                        self?.statusHintLabel.text = "已达标"
//                    } else {
//                        self?.statusHintLabel.text = "未达标"
//                    }
//                } else {
//                    self?.totalScoreLabel.text = "0"
//                    self?.bxScoreLabel.text = "0"
//                    self?.jmScoreLabel.text = "0"
//                    self?.dxScoreLabel.text = "0"
//                    self?.mdScoreLabel.text = "0"
//                    self?.statusHintLabel.text = "未达标"
//
//                    print("DEBUG: Refresh BY Credits Failed.")
//                }
//            }
//        }
    }
}


// MARK: TableView Delegate
extension BAContentViewController: UITableViewDelegate {

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
extension BAContentViewController: UITableViewDataSource {
    
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

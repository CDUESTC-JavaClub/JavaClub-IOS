//
//  STContentViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/26.
//

import UIKit
import Defaults
import Kingfisher

class STContentViewController: UIViewController {
    @IBOutlet var banner: UIImageView!
    @IBOutlet var avatar: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var signatureLabel: UILabel!
    @IBOutlet var userMediaStack: UIStackView!
    @IBOutlet var tableView: UITableView!
    
    private var useDarkModeSwitch: UISwitch!
    private var useSystemAppearanceSwitch: UISwitch!
    
    var models: [STSection] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let _ = Defaults.observe(.user) { [weak self] obj in
            self?.didUpdateLoginState(obj.newValue)
        }.tieToLifetime(of: self)
        
        let _ = Defaults.observe(.avatarLocal) { [weak self] obj in
            self?.updateUserMedia(avatarURL: obj.newValue, bannerURL: nil)
        }.tieToLifetime(of: self)
        
        let _ = Defaults.observe(.bannerLocal) { [weak self] obj in
            self?.updateUserMedia(avatarURL: nil, bannerURL: obj.newValue)
        }.tieToLifetime(of: self)
        
        setup()
        configureAppearance()
        configureModels()
        loadInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        configureAppearance()
    }
}


// MARK: Actions -
extension STContentViewController {
    
    private func switchDidToggle(_ sender: UISwitch) {
        switch sender {
        case useDarkModeSwitch:
            Defaults[.useDarkMode] = sender.isOn
            if !useSystemAppearanceSwitch.isOn {
                view.window?.overrideUserInterfaceStyle = sender.isOn ? .dark : .light
            }
            
        case useSystemAppearanceSwitch:
            if sender.isOn {
                useDarkModeSwitch.isOn = true
                useDarkModeSwitch.isEnabled = false
                view.window?.overrideUserInterfaceStyle = .unspecified
            } else {
                useDarkModeSwitch.isEnabled = true
                view.window?.overrideUserInterfaceStyle = useDarkModeSwitch.isOn ? .dark : .light
            }
            Defaults[.useSystemAppearance] = sender.isOn
            
        default:
            break
        }
    }
}


// MARK: Private Methods -
extension STContentViewController {
    
    private func setup() {
        avatar.layer.masksToBounds = false
        avatar.layer.cornerRadius = 63
        avatar.clipsToBounds = true
        
        tableView.register(STTappableViewCell.self, forCellReuseIdentifier: STTappableViewCell.identifier)
        tableView.register(STSwitchTableViewCell.self, forCellReuseIdentifier: STSwitchTableViewCell.identifier)
        tableView.register(STStaticTableViewCell.self, forCellReuseIdentifier: STStaticTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureModels() {
        models = [
            STSection(title: "绑定信息", options: [
                ._static(model: STStaticOption(title: "已绑定学号", icon: nil, value: Defaults[.user]?.studentID ?? "")),
                ._static(model: STStaticOption(title: "已绑定邮箱", icon: nil, value: Defaults[.user]?.email ?? "")),
            ]),
            STSection(title: "外观设置", options: [
                .switchable(model: STSwitchOption(
                    title: "使用深色模式",
                    icon: nil,
                    isOn: Defaults[.useDarkMode],
                    isEnabled: !Defaults[.useSystemAppearance],
                    handler: { [unowned self] _switch in
                        switchDidToggle(_switch)
                    }
                )),
                .switchable(model: STSwitchOption(
                    title: "主题外观跟随系统",
                    icon: nil,
                    isOn: Defaults[.useSystemAppearance],
                    isEnabled: true,
                    handler: { [unowned self] _switch in
                        switchDidToggle(_switch)
                    }
                )),
            ]),
            STSection(title: "更多", options: [
                .tappable(model: STTappableOption(title: "检查更新", icon: UIImage(named: "update_icon"), handler: {
                    
                })),
                .tappable(model: STTappableOption(title: "退出登录", icon: UIImage(named: "logout_icon"), handler: {
                    JCAccountManager.shared.logout()
                })),
            ]),
        ]
        
        tableView.reloadData()
    }
    
    private func configureAppearance() {
        if isDarkMode {
            view.backgroundColor = UIColor(hex: "000000")
        } else {
            view.backgroundColor = UIColor(hex: "F2F2F7")
        }
    }
    
    private func loadInfo() {
        didUpdateLoginState(Defaults[.user])
    }
    
    private func didUpdateLoginState(_ userInfo: JCUser?) {
        if let userInfo = userInfo {
            usernameLabel.text = userInfo.username
            signatureLabel.text = userInfo.signature
            
            if let avatarLocal = Defaults[.avatarLocal], let bannerLocal = Defaults[.bannerLocal] {
                updateUserMedia(avatarURL: avatarLocal, bannerURL: bannerLocal)
            }
        } else {
            usernameLabel.text = "请先登录"
            signatureLabel.text = ""
            avatar.image = UIImage.fromColor(.clear)
            banner.image = UIImage.fromColor(.clear)
        }
        
        configureModels()
    }
    
    private func updateUserMedia(avatarURL: URL?, bannerURL: URL?) {
        if let avatarURL = avatarURL {
            avatar.kf.setImage(with: avatarURL, options: [.keepCurrentImageWhileLoading]) { result in
                switch result {
                case .success(_):
                    print("DEBUG: Avatar Retrieved Successfully.")
                    
                default:
                    print("DEBUG: Avatar Retrieved Failed.")
                }
            }
        }
        
        if let bannerURL = bannerURL {
            banner.kf.setImage(with: bannerURL, options: [.keepCurrentImageWhileLoading]) { result in
                switch result {
                case .success(_):
                    print("DEBUG: Banner Retrieved Successfully.")
                    
                default:
                    print("DEBUG: Banner Retrieved Failed.")
                }
            }
        }
    }
}


// MARK: TableView Delegate
extension STContentViewController: UITableViewDelegate {

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
extension STContentViewController: UITableViewDataSource {
    
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
                withIdentifier: STTappableViewCell.identifier,
                for: indexPath
            ) as? STTappableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model)
            
            return cell
            
        case .switchable(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: STSwitchTableViewCell.identifier,
                for: indexPath
            ) as? STSwitchTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model) { [unowned self] _switch in
                if model.title == "使用深色模式" {
                    useDarkModeSwitch = _switch
                    
                    if Defaults[.useSystemAppearance] {
                        useDarkModeSwitch.isOn = true
                        useDarkModeSwitch.isEnabled = false
                    }
                } else if model.title == "主题外观跟随系统" {
                    useSystemAppearanceSwitch = _switch
                }
            }
            
            return cell
            
        case ._static(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: STStaticTableViewCell.identifier,
                for: indexPath
            ) as? STStaticTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        
        return section.title
    }
}

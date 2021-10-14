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
    
    private var models: [TVSection] = []
    private var lastRefreshTime = Date()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let _ = Defaults.observe(.user) { [weak self] obj in
            self?.didUpdateLoginState(obj.newValue)
        }.tieToLifetime(of: self)
        
//        let _ = Defaults.observe(.avatarLocal) { [weak self] obj in
//            self?.updateUserMedia(avatarURL: obj.newValue, bannerURL: nil)
//        }.tieToLifetime(of: self)
//
//        let _ = Defaults.observe(.bannerLocal) { [weak self] obj in
//            self?.updateUserMedia(avatarURL: nil, bannerURL: obj.newValue)
//        }.tieToLifetime(of: self)
        
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
        
        tableView.register(TappableViewCell.self, forCellReuseIdentifier: TappableViewCell.identifier)
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        tableView.register(StaticTableViewCell.self, forCellReuseIdentifier: StaticTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        // Set Inset For 20 Temporarily
        tableView.contentInset = .init(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    private func configureModels() {
        models = [
            TVSection(title: "绑定信息", options: [
                ._static(model: TVStaticOption(title: "已绑定学号", icon: nil, value: Defaults[.user]?.studentID ?? "")),
                ._static(model: TVStaticOption(title: "已绑定邮箱", icon: nil, value: Defaults[.user]?.email ?? "")),
            ]),
            TVSection(title: "外观设置", options: [
                .switchable(model: TVSwitchOption(
                    title: "使用深色模式",
                    icon: nil,
                    isOn: Defaults[.useDarkMode],
                    isEnabled: !Defaults[.useSystemAppearance],
                    handler: { [weak self] _switch in
                        self?.switchDidToggle(_switch)
                    }
                )),
                .switchable(model: TVSwitchOption(
                    title: "主题外观跟随系统",
                    icon: nil,
                    isOn: Defaults[.useSystemAppearance],
                    isEnabled: true,
                    handler: { [weak self] _switch in
                        self?.switchDidToggle(_switch)
                    }
                )),
            ]),
            TVSection(title: "更多", options: [
                .tappable(model: TVTappableOption(title: "检查更新", icon: UIImage(named: "update_icon"), handler: {
                    
                })),
                .tappable(model: TVTappableOption(title: "退出登录", icon: UIImage(named: "logout_icon"), handler: {
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
            
            updateUserMedia(startUp: true, avatarURL: Defaults[.avatarURL], bannerURL: Defaults[.bannerURL])
        } else {
            usernameLabel.text = "请先登录"
            signatureLabel.text = ""
            avatar.image = UIImage.fromColor(.clear)
            banner.image = UIImage.fromColor(.clear)
        }
        
        configureModels()
    }
    
    #warning("Fetch Banner Might Fail.")
    func updateUserMedia(startUp: Bool = false, avatarURL: URL?, bannerURL: URL?) {
        // Check Refresh Rate
        if !startUp, Date().timeIntervalSince(lastRefreshTime) < 180 {
            print("DEBUG: Not Enough Time For Next Refresh.")
            return
        } else {
            lastRefreshTime = Date()
        }
        
        if let avatarURL = avatarURL {
            ImageDownloader.default.downloadImage(with: avatarURL) { [weak self] result in
                switch result {
                case .success(let img):
                    self?.avatar.image = img.image
                    ImageCache.default.storeToDisk(img.originalData, forKey: "avatarKey")
                    print("DEBUG: Fetch Avatar Succeeded.")
                    
                case .failure(let error):
                    print("DEBUG: Fetch Avatar Failed With Error: \(String(describing: error))")
                    
                    ImageCache.default.retrieveImage(forKey: "avatarKey") { result in
                        switch result {
                        case .success(let image):
                            self?.avatar.image = image.image
                            print("DEBUG: Using Local Cached Avatar.")
                            
                        case .failure(let error):
                            print("DEBUG: Get Local Avatar Failed With Error: \(String(describing: error))")
                            self?.avatar.image = UIImage.fromColor(.clear)
                        }
                    }
                }
            }
        }
        
        if let bannerURL = bannerURL {
            ImageDownloader.default.downloadImage(with: bannerURL) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.banner.image = image.image
                    ImageCache.default.storeToDisk(image.originalData, forKey: "bannerKey")
                    print("DEBUG: Fetch Banner Succeeded.")
                    
                case .failure(let error):
                    print("DEBUG: Fetch Banner Failed With Error: \(String(describing: error))")
                    
                    ImageCache.default.retrieveImage(forKey: "bannerKey") { result in
                        switch result {
                        case .success(let image):
                            self?.banner.image = image.image
                            print("DEBUG: Using Local Cached Banner.")
                            
                        case .failure(let error):
                            print("DEBUG: Get Local Banner Failed With Error: \(String(describing: error))")
                            self?.banner.image = UIImage.fromColor(.clear)
                        }
                    }
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
                withIdentifier: TappableViewCell.identifier,
                for: indexPath
            ) as? TappableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model, type: .none)
            
            return cell
            
        case .switchable(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier,
                for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: model) { _switch in
                if model.title == "使用深色模式" {
                    if Defaults[.useSystemAppearance] {
                        _switch.isOn = true
                        _switch.isEnabled = false
                    }
                    useDarkModeSwitch = _switch
                } else if model.title == "主题外观跟随系统" {
                    useSystemAppearanceSwitch = _switch
                }
            }
            
            return cell
            
        case ._static(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: StaticTableViewCell.identifier,
                for: indexPath
            ) as? StaticTableViewCell else {
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

//
//  STContentViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/26.
//

import UIKit
import Defaults

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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let _ = Defaults.observe(.jcUser) { [weak self] obj in
            self?.didUpdateLoginState(userInfo: obj.newValue)
        }.tieToLifetime(of: self)
        
        let _ = Defaults.observe(.avatarURL) { [weak self] obj in
            self?.updateAvatar(obj.newValue)
        }.tieToLifetime(of: self)
        
        let _ = Defaults.observe(.bannerURL) { [weak self] obj in
            self?.updateBanner(obj.newValue)
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
//        tableView.contentInset = .init(top: 0, left: 0, bottom: 20, right: 0)
    }
    
    private func configureModels() {
        models = [
            TVSection(title: "????????????".localized(), options: [
                ._static(model: TVStaticOption(title: "???????????????".localized(), icon: nil, value: Defaults[.jcUser]?.studentID ?? "?????????".localized())),
                ._static(model: TVStaticOption(title: "???????????????".localized(), icon: nil, value: Defaults[.jcUser]?.email ?? "?????????".localized())),
            ]),
            TVSection(title: "????????????".localized(), options: [
                .switchable(model: TVSwitchOption(
                    title: "??????????????????".localized(),
                    icon: nil,
                    isOn: Defaults[.useDarkMode],
                    isEnabled: !Defaults[.useSystemAppearance],
                    handler: { [weak self] _switch in
                        self?.switchDidToggle(_switch)
                    }
                )),
                .switchable(model: TVSwitchOption(
                    title: "????????????????????????".localized(),
                    icon: nil,
                    isOn: Defaults[.useSystemAppearance],
                    isEnabled: true,
                    handler: { [weak self] _switch in
                        self?.switchDidToggle(_switch)
                    }
                )),
            ]),
            TVSection(title: "", options: [
                .tappable(model: TVTappableOption(title: "????????????".localized(), icon: UIImage(named: "about_us_icon"), handler: { [weak self] in
                    let infoVC = UIStoryboard(name: "Settings", bundle: .main)
                        .instantiateViewController(withIdentifier: "STInfoViewController")
                    as! STInfoViewController
                    
                    self?.navigationController?.isNavigationBarHidden = false
                    self?.navigationController?.pushViewController(infoVC, animated: true)
                })),
                .tappable(model: TVTappableOption(title: "????????????".localized(), icon: UIImage(named: "update_icon"), handler: {
                    if let createURL = URL(string: "https://apps.apple.com/cn/app/javaclub/id1590327368?l=en") {
                        UIApplication.shared.open(createURL)
                    }
                })),
                .tappable(model: TVTappableOption(title: "????????????".localized(), icon: UIImage(named: "logout_icon"), handler: { [weak self] in
                    if let tabBarController = self?.view.window?.rootViewController as? UITabBarController {
                        tabBarController.selectedIndex = 0
                    }
                    JCAccountManager.shared.logout(clean: true)
                })),
            ]),
        ]
        
        tableView.reloadData()
    }
    
    private func configureAppearance() {
        if isDarkMode {
            view.backgroundColor = UIColor(hex: "151515")
            tableView.backgroundColor = UIColor(hex: "151515")
        } else {
            view.backgroundColor = UIColor(hex: "F2F2F7")
            tableView.backgroundColor = UIColor(hex: "F2F2F7")
        }
    }
    
    private func didUpdateLoginState(userInfo: JCUser?) {
        if let userInfo = userInfo {
            usernameLabel.text = userInfo.username
            signatureLabel.text = "???\(userInfo.signature ?? "??????????????????????????????????????????")???"
        } else {
            usernameLabel.text = "????????????".localized()
            signatureLabel.text = ""
        }
        
        configureModels()
    }
    
    func updateAvatar(_ avatarURL: URL?) {
        if let avatarURL = avatarURL {
            retrieveImage(avatarURL, for: "avatarKey") { [weak self] result in
                switch result {
                    case .success(let image):
                        self?.avatar.image = image
                        print("DEBUG: Fetch Avatar Succeeded.")
                    
                    case .failure(let error):
                        self?.avatar.image = UIImage(named: "user_holder")
                        print("DEBUG: Fetch Avatar Failed With Error: \(String(describing: error))")
                }
            }
        } else if JCLoginState.shared.jc {
            JCAccountManager.shared.getUserMedia()
        } else {
            avatar.image = UIImage(named: "user_holder")
        }
    }
    
    func updateBanner(_ bannerURL: URL?) {
        if let bannerURL = bannerURL {
            retrieveImage(bannerURL, for: "bannerKey") { [weak self] result in
                switch result {
                    case .success(let image):
                        self?.banner.image = image
                        print("DEBUG: Fetch Banner Succeeded.")
                    
                    case .failure(let error):
                        self?.banner.image = UIImage(named: "login_bg")
                        print("DEBUG: Fetch Banner Failed With Error: \(String(describing: error))")
                }
            }
        } else if JCLoginState.shared.jc {
            JCAccountManager.shared.getUserMedia()
        } else {
            banner.image = UIImage.fromColor(.clear)
        }
    }
    
    private func retrieveImage(_ imgURL: URL, for key: String, completion: @escaping (Result<UIImage, JCError>) -> Void) {
        JCImageManager.shared.fetch(from: imgURL) { result in
            if let result = result {
                JCImageManager.shared.store(result.originalData, forKey: key)
                print("DEBUG: Fetch Image Succeeded.")
                completion(.success(result.image))
            } else {
                print("DEBUG: Fetch Image Failed. Getting Local.")
                
                JCImageManager.shared.local(for: key) { img in
                    if let img = img {
                        print("DEBUG: Using Local Cached Image.")
                        completion(.success(img))
                    } else {
                        print("DEBUG: Get Local Image Failed.")
                        completion(.failure(.imgRetrieveFailed))
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
                if model.title == "??????????????????" || model.title == "Use Dark mode" {
                    if Defaults[.useSystemAppearance] {
                        _switch.isOn = true
                        _switch.isEnabled = false
                    }
                    useDarkModeSwitch = _switch
                } else if model.title == "????????????????????????" || model.title == "Use System Appearance" {
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

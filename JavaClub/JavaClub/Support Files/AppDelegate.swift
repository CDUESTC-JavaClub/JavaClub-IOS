//
//  AppDelegate.swift
//  JavaClub
//
//  Created by Roy on 2021/9/24.
//

import UIKit
import Defaults

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var orientationLock = UIInterfaceOrientationMask.all
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        addObservers()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        JCAccountManager.shared.logout()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        orientationLock
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


extension AppDelegate {
    
    func loginJC(_ info: JCLoginInfo, onSuccess: (() -> Void)?, onFailure: (() -> Void)?) {
        JCAccountManager.shared.login(info: info) { result in
            if let success = try? result.get(), success {
                Defaults[.jcLoginInfo] = info
                
                JCAccountManager.shared.getInfo { result in
                    switch result {
                    case .success(let userInfo):
                        Defaults[.jcUser] = userInfo
                        onSuccess?()
                        
                    case .failure(let error):
                        print("DEBUG: Fetch User Info Failed With Error: \(String(describing: error))")
                        JCAccountManager.shared.logout(clean: true)
                    }
                }
            } else {
                onFailure?()
            }
        }
    }
    
    func loginJCIfAvailable(onFailure: (() -> Void)? = nil) {
        if !Defaults[.firstLogin], let info = Defaults[.jcLoginInfo] {
            loginJC(info) {
                print("DEBUG: Auto Login JC Succeeded.")
                JCLoginState.shared.jc = true
            } onFailure: {
                print("DEBUG: Auto Login JC Failed.")
                onFailure?()
            }
        } else {
            print("DEBUG: First Login Or Login Info Not Found.")
            
            if !Defaults[.jcLoginInfo].isNil {
                JCAccountManager.shared.logout(clean: true)
            }
        }
    }
    
    private func addObservers() {
        let _ = Defaults.observe(.jcUser) { obj in
            JCLoginState.shared.isBound = obj.newValue?.studentID != nil
        }.tieToLifetime(of: self)
    }
}


// MARK: Defaults Keys -
extension Defaults.Keys {
    // JC Info
    static let jcLoginInfo = Key<JCLoginInfo?>("jcLoginInfoKey", default: nil)
    static let jcUser = Key<JCUser?>("jcUserInfoKey", default: nil)
    static let sessionURL = Key<URL?>("sessionURLKey", default: nil)
    
    // JW Info
    static let jwLoginInfo = Key<KALoginInfo?>("jwLoginInfoKey", default: nil)
    static let enrollment = Key<KAEnrollment?>("enrollmentInfoKey", default: nil)
    
    // BY Info
    static let byLoginInfo = Key<BALoginInfo?>("byLoginInfoKey", default: nil)
    static let byAccount = Key<BAAccount?>("byUserKey", default: nil)
    
    // Settings
    static let avatarURL = Key<URL?>("avatarURLKey", default: nil)
    static let bannerURL = Key<URL?>("bannerURLKey", default: nil)
    static let useDarkMode = Key<Bool>("useDarkModeKey", default: true)
    static let useSystemAppearance = Key<Bool>("useSystemAppearanceKey", default: true)
    
    // Environment
    static let firstLogin = Key<Bool>("firstLoginKey", default: true)
    static let classTableTerm = Key<Int>("classTableTermKey", default: 4)
    static let classTableJsonData = Key<Data?>("classTableJsonDataKey", default: nil)
}

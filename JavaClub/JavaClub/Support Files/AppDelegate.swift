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



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        addObservers()
        loginIfAvailable()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
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
    
    func loginIfAvailable() {
        if Defaults[.sessionExpired] {
            JCAccountManager.shared.refreshUserMedia()
            
            if let jwInfo = Defaults[.jwInfo], let user = Defaults[.user] {
                JCAccountManager.shared.loginJW(info: jwInfo, bind: user.studentID == nil) { result in
                    if let success = try? result.get(), success {
                        JCAccountManager.shared.getEnrollmentInfo { result in
                            let enr = try? result.get()
                            Defaults[.enrollment] = enr
                        }
                    } else {
                        print("DEBUG: Auto Login JW Failed.")
                    }
                }
            }
        }
    }
    
    private func addObservers() {
        let _ = Defaults.observe(.user) { key in
            JCLoginState.shared.isBound = key.newValue?.studentID != nil
        }.tieToLifetime(of: self)
        
        let _ = Defaults.observe(.jwInfo) { key in
            JCLoginState.shared.jw = !key.newValue.isNil
        }.tieToLifetime(of: self)
        
        let _ = Defaults.observe(.loginInfo) { key in
            JCLoginState.shared.jc = !key.newValue.isNil
        }.tieToLifetime(of: self)
    }
}


// MARK: Defaults Keys -
extension Defaults.Keys {
    // User Info
    static let loginInfo = Key<JCLoginInfo?>("loginInfoKey", default: nil)
    static let jwInfo = Key<KALoginInfo?>("bindingInfoKey", default: nil)
    static let user = Key<JCUser?>("userKey", default: nil)
    static let sessionURL = Key<URL?>("sessionURLKey", default: nil)
    static let sessionExpired = Key<Bool>("sessionExpiredKey", default: false)
    static let avatarLocal = Key<URL?>("avatarLocalKey", default: nil)
    static let bannerLocal = Key<URL?>("bannerLocalKey", default: nil)
    static let avatarURL = Key<URL?>("avatarURLKey", default: nil)
    static let bannerURL = Key<URL?>("bannerURLKey", default: nil)
    static let enrollment = Key<KAEnrollment?>("bannerURLKey", default: nil)
    
    // Settings
    static let useDarkMode = Key<Bool>("useDarkModeKey", default: true)
    static let useSystemAppearance = Key<Bool>("useSystemAppearanceKey", default: true)
}

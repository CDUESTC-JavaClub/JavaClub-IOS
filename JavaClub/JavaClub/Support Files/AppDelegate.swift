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
        loginIfAvailable()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        JCAccountManager.shared.logout(clean: false)
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
        if let loginInfo = Defaults[.loginInfo] {
            JCAccountManager.shared.login(info: loginInfo) { _ in
                if Defaults[.sessionURL].isNil || Defaults[.sessionExpired] {
                    JCAccountManager.shared.refreshCompletely()
                }
                
                if Defaults[.avatarLocal].isNil || Defaults[.bannerLocal].isNil {
                    JCAccountManager.shared.refreshUserMedia()
                }
            }
        }
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

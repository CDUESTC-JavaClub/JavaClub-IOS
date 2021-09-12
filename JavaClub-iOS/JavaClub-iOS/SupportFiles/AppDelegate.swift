//
//  AppDelegate.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import UIKit
import WebKit
import Defaults

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let info = Defaults[.loginInfo] {
            loginIfAvailable(info)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // TODO: Test If Can Clean Caches & Cookies
        
        if Defaults[.loginInfo] == nil {
            HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)

            WKWebsiteDataStore
                .default()
                .removeData(
                    ofTypes: [WKWebsiteDataTypeCookies],
                    modifiedSince: Date.distantPast,
                    completionHandler: {}
                )
        }
        
        JCAccountManager.shared.logout()
    }
    
    func loginIfAvailable(_ loginInfo: JCLoginInfo?) {
        if let loginInfo = loginInfo {
            JCAccountManager.shared.login(info: loginInfo) { loginRes in
                if let response = try? loginRes.get(), response == true {
                    // Login Successful
                    JCAccountManager.shared.getInfo { infoRes in
                        if let user = try? infoRes.get() {
                            Defaults[.user] = user
                            Defaults[.loginInfo] = loginInfo
                        }
                    }
                    
                    // Re-login
                    if Defaults[.sessionURL] == nil {
                        JCAccountManager.shared.refreshCompletely()
                    }
                }
            }
        }
    }
}


extension Defaults.Keys {
    // User Info
    static let loginInfo = Key<JCLoginInfo?>("loginInfoKey", default: nil)
    static let jwInfo = Key<KCLoginInfo?>("jwInfoKey", default: nil)
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

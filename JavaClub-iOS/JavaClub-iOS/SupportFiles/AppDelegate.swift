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
        if let info = Defaults[.rememberedUser] {
            JCAccountManager.shared.login(info: info) { user in
                if let user = user {
                    JCUserState.shared.isLoggedIn = true
                    JCUserState.shared.url = user.redirectionURL
                    JCUserState.shared.currentUser = user
                }
            }
        }
        
        return true
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

    func applicationWillTerminate(_ application: UIApplication) {
        // TODO: Test If Can Clean Caches & Cookies
        
//        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
//
//        WKWebsiteDataStore
//            .default()
//            .removeData(
//                ofTypes: [WKWebsiteDataTypeCookies],
//                modifiedSince: Date.distantPast,
//                completionHandler: {}
//            )
        
        JCAccountManager.shared.logout()
    }
}


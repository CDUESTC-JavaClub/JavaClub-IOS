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
        loginIfAvailable()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
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
                Defaults[.loginInfo] = info
                
                JCAccountManager.shared.getInfo { result in
                    switch result {
                    case .success(let userInfo):
                        Defaults[.user] = userInfo
                        
                    case .failure(let error):
                        print("DEBUG: Fetch User Info Failed With Error: \(String(describing: error))")
                        JCAccountManager.shared.logout()
                    }
                }
                
                onSuccess?()
            } else {
                onFailure?()
            }
        }
    }
    
    private func loginIfAvailable() {
        if !Defaults[.firstLogin], let info = Defaults[.loginInfo] {
            loginJC(info) {
                print("DEBUG: Auto Login JC Succeeded.")
                
                if let jwInfo = Defaults[.jwInfo], let user = Defaults[.user] {
                    JCAccountManager.shared.loginJW(info: jwInfo, bind: user.studentID == nil) { result in
                        
                        switch result {
                        case .success(let success):
                            if success {
                                JCAccountManager.shared.getEnrollmentInfo { result in
                                    
                                    switch result {
                                    case .success(let enr):
                                        Defaults[.enrollment] = enr
                                        print("DEBUG: Auto Login JW Succeeded.")
                                        
                                    case .failure(let error):
                                        if error == .notLoginJC {
                                            print("DEBUG: Please Login JC First.")
                                        } else {
                                            print("DEBUG: Fetch Enrollment Info Failed With Error: \(String(describing: error))")
                                        }
                                    }
                                    
                                }
                            } else {
                                print("DEBUG: Auto Login JW Failed. (Maybe Wrong Username Or Password)")
                            }
                            
                        case .failure(let error):
                            print("DEBUG: Auto Login JW Failed With Error: \(String(describing: error)).")
                        }
                    }
                } else {
                    print("DEBUG: JW Credential Lost.")
                }
            } onFailure: {
                print("DEBUG: Auto Login JC Failed.")
            }
        } else {
            print("DEBUG: First Login Or Login Info Not Found.")
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
    static let jwInfo = Key<KALoginInfo?>("jwInfoKey", default: nil)
    static let byInfo = Key<BALoginInfo?>("byInfoKey", default: nil)
    static let user = Key<JCUser?>("userInfoKey", default: nil)
    static let sessionURL = Key<URL?>("sessionURLKey", default: nil)
    static let avatarURL = Key<URL?>("avatarURLKey", default: nil)
    static let bannerURL = Key<URL?>("bannerURLKey", default: nil)
    static let enrollment = Key<KAEnrollment?>("enrollmentInfoKey", default: nil)
    
    // Settings
    static let useDarkMode = Key<Bool>("useDarkModeKey", default: true)
    static let useSystemAppearance = Key<Bool>("useSystemAppearanceKey", default: true)
    
    // Environment
    static let firstLogin = Key<Bool>("firstLoginKey", default: true)
    static let classTableTerm = Key<Int>("classTableTermKey", default: 4)
    static let classTableJsonData = Key<Data?>("classTableJsonDataKey", default: nil)
}

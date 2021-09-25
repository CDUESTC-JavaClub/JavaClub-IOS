//
//  JCWebViewController.swift
//  JavaClub
//
//  Created by Roy on 2021/9/24.
//

import UIKit
import WebKit

class JCWebViewController: UIViewController {
    private let url: URL
    private let loginVC: JCLoginViewController!
    
    private let webView: WKWebView = {
        let preferences = WKWebpagePreferences()
        if #available(iOS 14.0, *) {
            preferences.allowsContentJavaScript = true
        }
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: configuration)
        
        return webView
    }()
    
    
    init(url: URL) {
        self.url = url
        
        loginVC = UIStoryboard(name: "JavaClub", bundle: .main)
            .instantiateViewController(withIdentifier: "JCLoginViewController")
        as? JCLoginViewController
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(webView)
        webView.load(URLRequest(url: url))
        
        UITabBar.appearance().isHidden = true
        present(loginVC, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = view.bounds
    }
}

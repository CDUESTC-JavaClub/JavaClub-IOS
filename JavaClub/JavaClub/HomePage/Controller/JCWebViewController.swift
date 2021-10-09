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
    private let webView: WKWebView
    
    
    init(url: URL) {
        self.url = url
        self.webView = WebView(request: URLRequest(url: url)).make()
        
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = view.bounds
    }
}


class WebView {
    static var cache = [URL: WKWebView]()
    let request: URLRequest
    var completion: (() -> Void)?
    
    
    init(request: URLRequest, _ completion: (() -> Void)? = nil) {
        self.request = request
        self.completion = completion
    }
    
    func make() -> WKWebView {
        guard let url = request.url else { fatalError("URL cannot be used.") }

        if let webView = WebView.cache[url] {
            return webView
        }
        
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        WebView.cache[url] = webView
        
        completion?()
        
        return webView
    }
}

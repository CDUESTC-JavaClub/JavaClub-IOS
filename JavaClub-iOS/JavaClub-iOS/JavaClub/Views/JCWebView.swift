//
//  JCWebView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI
import WebKit

struct JCWebView: View {
    @Binding var url: URL?
    @Binding var sessionExpired: Bool
    
    var body: some View {
        if let url = url {
            if !sessionExpired {
                WebView(request: URLRequest(url: url), completion: {
                    sessionExpired = true
                })
                .padding(.bottom, 50)
            } else {
                WebView(request: URLRequest(url: URL(string: "https://study.cduestc.club/index.php")!))
                    .padding(.bottom, 50)
            }
        }
    }
}


struct WebView : UIViewRepresentable {
    static var cache = [URL: WKWebView]()
    let request: URLRequest
    var completion: (() -> Void)?
    
    func makeUIView(context: Context) -> WKWebView  {
        guard let url = request.url else { fatalError("URL cannot be used.") }

        if let webView = WebView.cache[url] {
            return webView
        }

        let webView = WKWebView()
        WebView.cache[url] = webView
        
        completion?()
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url == nil {
            uiView.load(request)
        }
    }
    
}

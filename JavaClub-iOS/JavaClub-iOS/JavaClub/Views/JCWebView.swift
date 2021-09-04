//
//  JCWebView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI
import WebKit

struct JCWebView: View {
    @Binding var url: String
    
    var body: some View {
        WebView(request: URLRequest(url: URL(string: url)!))
            .padding(.bottom, 50)
    }
}


struct WebView : UIViewRepresentable {
    static var cache = [URL: WKWebView]()
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        guard let url = request.url else { fatalError("URL cannot be used.") }

        if let webView = WebView.cache[url] {
            return webView
        }

        let webView = WKWebView()
        WebView.cache[url] = webView
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url == nil {
            uiView.load(request)
        }
    }
    
}

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
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}

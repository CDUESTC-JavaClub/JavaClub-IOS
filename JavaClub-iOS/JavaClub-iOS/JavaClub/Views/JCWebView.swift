//
//  JCWebView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI
import WebKit

struct JCWebView: View {
    @Binding var isLoggedIn: Bool
    @Binding var url: String
    @State private var showingLogin: Bool = false
    
    var body: some View {
        if isLoggedIn, !url.isEmpty {
            WebView(request: URLRequest(url: URL(string: url)!))
                .padding(.bottom, 50)
        } else {
            Button {
                showingLogin = true
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(Color.white)
                        .frame(width: 40, height: 40)
                        .shadow(radius: 5)
                        .opacity(0.5)
                    
                    Text("Login".localized())
                        .fixedSize()
                }
            }
            .sheet(isPresented: $showingLogin) {
                JCLoginView(showingLogin: $showingLogin)
            }
        }
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

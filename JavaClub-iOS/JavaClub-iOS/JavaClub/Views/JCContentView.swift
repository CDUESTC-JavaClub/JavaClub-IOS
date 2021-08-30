//
//  JCContentView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI

struct JCContentView: View {
    var body: some View {
        WebView(request: URLRequest(url: URL(string: "https://www.baidu.com/")!))
    }
}

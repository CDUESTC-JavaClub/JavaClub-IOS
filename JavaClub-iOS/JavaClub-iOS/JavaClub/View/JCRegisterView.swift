//
//  JCRegisterView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI

struct JCRegisterView: View {
    
    var body: some View {
        WebView(request: URLRequest(
                    url: URL(string: "https://study.cduestc.club/index.php?register/")!
        ))
    }
}

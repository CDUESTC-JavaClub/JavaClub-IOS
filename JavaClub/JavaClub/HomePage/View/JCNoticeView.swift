//
//  JCNoticeView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/7.
//

import SwiftUI

struct JCNoticeView: View {
    var textStr: String
    
    var body: some View {
        Section {
            Text(textStr)
                .font(.callout)
                .foregroundColor(.secondary)
        }
    }
}

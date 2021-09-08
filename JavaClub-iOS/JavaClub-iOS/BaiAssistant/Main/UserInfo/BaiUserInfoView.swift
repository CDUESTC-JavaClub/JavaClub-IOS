//
//  BaiUserInfoView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/8.
//

import SwiftUI

struct BaiUserInfoView: View {
    
    var body: some View {
        Section {
            BaiScoreOverallView()
            
            BaiScoreDetailView()
        }
    }
}

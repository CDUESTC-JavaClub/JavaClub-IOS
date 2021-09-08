//
//  KAUserInfoView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/8.
//

import SwiftUI
import Defaults

struct KAUserInfoView: View {
    @Default(.enrollment) private var enrollment
    
    var body: some View {
        Section {
            HStack {
                Image("kc_student")
                    .resizable()
                    .frame(width: 100, height: 111)
                    .padding(.trailing)
                
                VStack(alignment: .leading) {
                    Text("Roy")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 2)
                    
                    Text("2018级 计算机类")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Text("学号：1840610908")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Text("所属：计算机学院（本科）")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

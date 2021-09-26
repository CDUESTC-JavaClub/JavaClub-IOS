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
                    Text(enrollment?.name ?? "N/A")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 2)
                    
                    Text("\(enrollment?.grade ?? "?")级 \(enrollment?.subject ?? "?")")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Text("学号：\(enrollment?.studentID ?? "?")")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Text("所属：\(enrollment?.department ?? "?")（\(enrollment?.degree ?? "?")）")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

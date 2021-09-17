//
//  KAActionView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/7.
//

import SwiftUI

struct KAActionView: View {
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        Section {
            Button {
                JCAccountManager.shared.getScore { result in
                    let score = try? result.get()
                    print("SCORE: \(score)")
                }
            } label: {
                HStack {
                    Image(systemName: "square.and.pencil")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 5)
                    
                    Text("学期成绩查询")
                    
                    Spacer()
                }
                .foregroundColor(scheme == .dark ? .white : .black)
            }
            
            NavigationLink(destination: KAClassTableView()) {
                HStack {
                    Image(systemName: "clock")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 5)
                    
                    Text("课程表查询")
                    
                    Spacer()
                }
                .foregroundColor(scheme == .dark ? .white : .black)
            }
            
            NavigationLink(destination: KAEnrollmentView()) {
                HStack {
                    Image(systemName: "person.crop.circle")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 5)
                    
                    Text("学籍信息查询")
                    
                    Spacer()
                }
                .foregroundColor(scheme == .dark ? .white : .black)
            }
        }
    }
}
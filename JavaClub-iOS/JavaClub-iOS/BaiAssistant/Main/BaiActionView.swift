//
//  BaiActionView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/8.
//

import SwiftUI

struct BaiActionView: View {
    @Environment(\.colorScheme) private var scheme
    
    var body: some View {
        Section {
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "person.2")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 21, height: 15)
                        .padding(.trailing, 13)
                    
                    Text("所有活动")
                    
                    Spacer()
                }
                .foregroundColor(scheme == .dark ? .white : .black)
            }
            
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "clock")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 14)
                    
                    Text("管理我的活动")
                    
                    Spacer()
                }
                .foregroundColor(scheme == .dark ? .white : .black)
            }
            
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 29, height: 20)
                        .padding(.trailing, 5)
                    
                    Text("百叶积分")
                    
                    Spacer()
                }
                .foregroundColor(scheme == .dark ? .white : .black)
            }
        }
    }
}

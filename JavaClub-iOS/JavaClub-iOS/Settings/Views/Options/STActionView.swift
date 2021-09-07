//
//  STActionView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/7.
//

import SwiftUI

struct STActionView: View {
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        Section {
            Button {
                checkUpdates()
            } label: {
                HStack {
                    Image(systemName: "goforward")
                        .resizable()
                        .frame(width: 18, height: 20)
                        .padding(.trailing, 7)
                    
                    Text("检查更新")
                    
                    Spacer()
                }
                .foregroundColor(scheme == .dark ? .white : .black)
            }
            
            Button {
                logout()
            } label: {
                HStack {
                    Image("settings_exit")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 5)
                    
                    Text("退出登录")
                    
                    Spacer()
                }
                .foregroundColor(scheme == .dark ? .white : .black)
            }
        }
    }
    
    
    private func checkUpdates() {
        
    }
    
    private func logout() {
        
    }
}

//
//  JCLoginView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI

struct JCLoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var showingLogin: Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingLoginFailedAlert: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background Image
                Image("login_bg")
                    .resizable()
                    .aspectRatio(geo.size, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center) {
                    Image("bai")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .padding(.top)
                        .padding(.bottom, 100)
                    
                    HStack(spacing: 15) {
                        Image(systemName: "person.fill")
                            .foregroundColor(.black)
                        
                        TextField("", text: $username)
                            .placeholder(when: username.isEmpty) {
                                Text("用户名")
                                    .foregroundColor(.gray)
                            }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color.white.opacity(0.3))
                    .clipShape(Capsule())
                    
                    HStack(spacing: 15) {
                        Image(systemName: "key.fill")
                            .foregroundColor(.black)
                        
                        TextField("".localized(), text: $password)
                            .placeholder(when: password.isEmpty) {
                                Text("密码")
                                    .foregroundColor(.gray)
                            }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color.white.opacity(0.3))
                    .clipShape(Capsule())
                    
                    Button {
                        if !username.isEmpty && !password.isEmpty {
                            JCAccountManager.shared.login(
                                info: JCLoginInfo(username: username, password: password)
                            ) { user in
                                if let user = user {
                                    JCUserState.shared.isLoggedIn = true
                                    JCUserState.shared.url = user.redirectionURL
                                    
                                    showingLogin = false
                                } else {
                                    showingLoginFailedAlert = true
                                }
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color.white)
                                .frame(width: 100, height: 40)
                                .shadow(radius: 5)
                                .opacity(0.5)
                            
                            Text("Login")
                                .font(.system(size: 15))
                                .fixedSize()
                                .padding()
                        }
                    }
                    .alert(isPresented: $showingLoginFailedAlert) {
                        Alert(
                            title: Text("错误"),
                            message: Text("登录失败，请检查账号密码后重试。"),
                            dismissButton: .default(Text("Got it!"))
                        )
                    }
                }
                .padding(.horizontal, 50)
            }
        }
    }
}

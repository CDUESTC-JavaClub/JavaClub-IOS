//
//  JCLoginView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI
import Defaults

struct JCLoginView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var showingLogin: Bool
    @Binding var loginInfo: JCLoginInfo?
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showingLoginFailedAlert: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack(alignment: .top) {
                    // Background Image
                    Image("login_bg")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(alignment: .center) {
                        // Dismiss Notice
                        Text("下滑关闭")
                            .fixedSize()
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .edgesIgnoringSafeArea(.top)
                        
                        // Icon
                        Image("logo")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .padding(.top)
                            .padding(.bottom, 70)
                        
                        // Textfields
                        HStack(spacing: 15) {
                            Image(systemName: "person.fill")
                                .foregroundColor(.black)
                            
                            TextField("", text: $username)
                                .placeholder(when: username.isEmpty) {
                                    Text("用户名或邮箱")
                                        .fixedSize()
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
                            
                            SecureField("".localized(), text: $password)
                                .placeholder(when: password.isEmpty) {
                                    Text("密码")
                                        .fixedSize()
                                        .foregroundColor(.gray)
                                }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(Color.white.opacity(0.3))
                        .clipShape(Capsule())
                        
                        // Register & Forgot Password
                        HStack {
                            NavigationLink(
                                destination: JCRegisterView(),
                                label: {
                                    Text("注册账号")
                                        .foregroundColor(.black)
                                        .underline()
                                        .fixedSize()
                                })
                            
                            Spacer()
                            
                            NavigationLink(
                                destination: JCForgotView(),
                                label: {
                                    Text("忘记密码？")
                                        .foregroundColor(.black)
                                        .underline()
                                        .fixedSize()
                                })
                        }
                        .padding(.top, 20)
                        
                        // Login Button
                        Button {
                            if !username.isEmpty && !password.isEmpty {
                                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                                
                                let loginInfo = JCLoginInfo(username: username, password: password)
                                appDelegate?.loginIfAvailable(loginInfo)
                            } else {
                                showingLoginFailedAlert = true
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .foregroundColor(Color.white)
                                    .frame(width: 100, height: 40)
                                    .shadow(radius: 5)
                                    .opacity(0.5)
                                
                                Text("登录")
                                    .font(.system(size: 15))
                                    .fixedSize()
                                    .padding()
                            }
                        }
                        .padding(.top, 20)
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
                .onTapGesture {
                    hideKeyboard()
                }
            }
        }
    }
}

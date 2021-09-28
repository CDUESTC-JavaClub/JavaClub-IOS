//
//  JCBindIDView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/12.
//

import SwiftUI
import Combine
import Defaults

struct JCBindIDView: View {
    @Binding var verifyLogin: Bool
    @Binding var verifyBinding: Bool
    @State private var id = ""
    @State private var pw = ""
    @State private var idIsTapped = false
    @State private var pwIsTapped = false
    @State private var bindState = false
    @State private var presentAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Text("请先登录教务")
                    .font(.title)
                
                Spacer()
            }
            .padding(.bottom, 50)
            
            // ID TextField
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 15) {
                    TextField("", text: $id) { status in
                        // If TextField Is Clicked
                        if status {
                            withAnimation(.easeIn) {
                                idIsTapped = true
                                
                                if pw.isEmpty {
                                    pwIsTapped = false
                                }
                            }
                        }
                    } onCommit: {
                        // If Return Button Is Pressed
                        if id.isEmpty {
                            withAnimation(.easeOut) {
                                idIsTapped = false
                                
                                if pw.isEmpty {
                                    pwIsTapped = false
                                }
                            }
                        }
                    }
                    .onReceive(Just(id)) { newText in
                        let filtered = newText.filter { "0123456789".contains($0) }
                        if filtered != newText {
                            id = filtered
                        }
                    }
                }
                .padding(.top, idIsTapped ? 15 : 0)
                .background(
                    
                    Text("学号")
                        .scaleEffect(idIsTapped ? 0.8 : 1)
                        .offset(x: idIsTapped ? -7 : 0, y: idIsTapped ? -15 : 0)
                        .foregroundColor(idIsTapped ? .accentColor : .gray)
                    
                    ,alignment: .leading
                )
                .padding(.horizontal)
                
                Rectangle()
                    .fill(idIsTapped ? Color.accentColor : .gray)
                    .opacity(idIsTapped ? 1 : 0.5)
                    .frame(height: 1)
                    .padding(.top, 10)
            }
            .padding(.top, 12)
            .background(Color.gray.opacity(0.09))
            .cornerRadius(5)
            
            HStack {
                Spacer()
                
                Text("\(id.count)/10")
                    .font(.caption)
                    .foregroundColor(id.count == 10 ? Color(hex: "88C0B4") : .gray)
                    .padding(.trailing)
                    .padding(.top, 4)
            }
            
            // Password Textfield
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 15) {
                    SecureField("", text: $pw) {
                        // If Return Button Is Pressed
                        if pw.isEmpty {
                            withAnimation(.easeOut) {
                                pwIsTapped = false
                                
                                if id.isEmpty {
                                    idIsTapped = false
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        withAnimation(.easeIn) {
                            pwIsTapped = true
                            
                            if id.isEmpty {
                                idIsTapped = false
                            }
                        }
                    }
                }
                .padding(.top, pwIsTapped ? 15 : 0)
                .background(
                    
                    Text("教务密码")
                        .scaleEffect(pwIsTapped ? 0.8 : 1)
                        .offset(x: pwIsTapped ? -7 : 0, y: pwIsTapped ? -15 : 0)
                        .foregroundColor(pwIsTapped ? .accentColor : .gray)
                    
                    ,alignment: .leading
                )
                .padding(.horizontal)
                
                Rectangle()
                    .fill(pwIsTapped ? Color.accentColor : .gray)
                    .opacity(pwIsTapped ? 1 : 0.5)
                    .frame(height: 1)
                    .padding(.top, 10)
            }
            .padding(.top, 12)
            .background(Color.gray.opacity(0.09))
            .cornerRadius(5)
            
            // Submit Button
            Button {
//                JCAccountManager.shared.bindStudentID(
//                    info: KCLoginInfo(id: id, password: pw)
//                ) { result in
//                    if
//                        let response = try? result.get(),
//                        response
//                    {
//                        bindState = true
//                        verify = true
//
//                        JCAccountManager.shared.getEnrollmentInfo { result in
//                            let enrollment = try? result.get()
//                            Defaults[.enrollment] = enrollment
//                        }
//                    } else {
//                        bindState = false
//                        verify = false
//                    }
//
//                    presentAlert = true
//                }
                if verifyLogin {
                    verifyBinding = true
                }
            } label: {
                Image(systemName: "arrow.right")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(hex: "141316"))
                    .clipShape(Circle())
            }
            .padding(.vertical)
            .alert(isPresented: $presentAlert) {
                Alert(
                    title: Text(bindState ? "成功" : "失败"),
                    message: Text(
                        bindState ? "学号绑定成功！" : "学号绑定失败，请检查输入是否有误，或网络连接是否通畅！"
                    ),
                    dismissButton: .default(
                        Text("Got it!")
                    )
                )
            }
        }
        .padding()
    }
}

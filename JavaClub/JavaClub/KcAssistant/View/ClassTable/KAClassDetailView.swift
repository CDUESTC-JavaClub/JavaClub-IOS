//
//  KAClassDetailView.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/10/27.
//

import SwiftUI

struct KAClassDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isShown: Bool
    var _class: KAClass?
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(alignment: .top) {
                Spacer()
                
                Button {
                    isShown = false
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.label)
                }
                .padding(.trailing, 10)
            }
            .padding(.top, 10)
            
            HStack {
                Image(systemName: "graduationcap.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.label)
                    .padding(.leading, 10)
                
                Text("课程名：\(_class!.name)")
                
                Spacer()
            }
            .frame(height: 20)
            
            HStack {
                Image(systemName: "number.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.label)
                    .padding(.leading, 10)
                
                Text("课程号：\(_class!.classID)")
                
                Spacer()
            }
            .frame(height: 20)
            
            HStack {
                Image(systemName: "clock.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.label)
                    .padding(.leading, 10)
                
                Text("时间：\(formatTime(for: _class!.indexSet.first!)) 星期\(_class!.day.chinese ?? "\(_class!.day)")（\(_class!.weekFrom)-\(_class!.weekTo) 周上）")
                
                Spacer()
            }
            .frame(height: 20)
            
            HStack {
                Image(systemName: "mappin.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.label)
                    .padding(.leading, 10)
                
                Text("地点：\(_class!.locale)")
                
                Spacer()
            }
            .frame(height: 20)
            
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.label)
                    .padding(.leading, 10)
                
                Text("教师：\(_class!.teacher)")
                
                Spacer()
            }
            .frame(height: 20)
        }
        .padding(.bottom, 20)
        .background(colorScheme == .light ? Color.white : .secondarySystemBackground)
        .cornerRadius(15)
    }
    
    
    func formatTime(for index: Int) -> String {
        switch index {
        case 1:
            return "8:15~9:50"
            
        case 2:
            return "10:05~11:30"
            
        case 3:
            return "14:00~15:35"
            
        case 4:
            return "15:50~17:25"
            
        case 5:
            return "18:30~20:05"
            
        default:
            return "第 \(index) 节".localized()
        }
    }
}

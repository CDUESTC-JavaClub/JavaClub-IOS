//
//  KAClassTableContentview.swift
//  JavaClub
//
//  Created by Roy on 2021/10/15.
//

import UIKit
import SwiftUI
import Defaults

fileprivate var colorHash: [String?] = Array(repeating: nil, count: 20)

fileprivate let colorSet: [String] = [
    "#30AB43", "#FF483D", "#D8873D", "#EAC822", "#5BB974",
    "#5B81CA", "#6B4E8B", "#854348", "#5B744C", "#AB5D61",
    "#DBA217", "#A6B35B", "#397E67", "#4A5F8F", "#814C6E",
    "#A22A22", "#4EA9A0", "#3B4A89", "#7C788D", "#245456",
]

struct KAClassTableContentview: View {
    @ObservedObject private var observable: KAClassTableObservable = .shared
    @Default(.classTableTerm) var term
    @State var presentAlert = false
    @State var showIndicator = false
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                VStack(spacing: 0) {
                    VStack {
                        Button {
                            
                        } label: {
                            HStack(spacing: 5) {
                                Text("第 \(term) 学期")
                                
                                Image(systemName: "chevron.down")
                                    .renderingMode(.template)
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    
                    HStack(spacing: 0) {
                        ForEach(1 ..< 8) { index in
                            switch index {
                            case 1:
                                Text("周一")
                                    .frame(width: geo.size.width / 7, height: 30)
                                    .foregroundColor(.white)
                                    .background(Color(hex: "60D1AE"))

                            case 2:
                                Text("周二")
                                    .frame(width: geo.size.width / 7, height: 30)
                                    .foregroundColor(.white)
                                    .background(Color(hex: "60D1AE"))

                            case 3:
                                Text("周三")
                                    .frame(width: geo.size.width / 7, height: 30)
                                    .foregroundColor(.white)
                                    .background(Color(hex: "60D1AE"))

                            case 4:
                                Text("周四")
                                    .frame(width: geo.size.width / 7, height: 30)
                                    .foregroundColor(.white)
                                    .background(Color(hex: "60D1AE"))

                            case 5:
                                Text("周五")
                                    .frame(width: geo.size.width / 7, height: 30)
                                    .foregroundColor(.white)
                                    .background(Color(hex: "60D1AE"))

                            case 6:
                                Text("周六")
                                    .frame(width: geo.size.width / 7, height: 30)
                                    .foregroundColor(.white)
                                    .background(Color(hex: "60D1AE"))

                            case 7:
                                Text("周日")
                                    .frame(width: geo.size.width / 7, height: 30)
                                    .foregroundColor(.white)
                                    .background(Color(hex: "60D1AE"))

                            default:
                                Text("")
                                    .frame(width: geo.size.width / 7, height: 30)
                                    .foregroundColor(.white)
                                    .background(Color(hex: "60D1AE"))
                            }
                        }
                    }
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(observable.classes, id: \.id) {
                                KAClassTableCell(className: $0.name, location: $0.locale, teacher: $0.teacher, color: Color(selectColor(with: $0.name) ?? .gray))
                                    .frame(height: 150)
                                    .padding(.top, 5)
                            }
                        }
                    }
                }
            }
            
            if showIndicator {
                GeometryReader { geo in
                    LoadingIndicatorView()
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                }
                .background(
                    Color.black
                        .opacity(0.45)
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }
        .alert(isPresented: $presentAlert) {
            Alert(title: Text("错误"), message: Text("暂无法获取该学期课表，请稍后再试。"), dismissButton: .default(Text("Got it!")))
        }
        .onAppear {
            showIndicator = true
            
            JCAccountManager.shared.getClassTable(term: term) { result in
                switch result {
                case .success(let classes):
                    observable.classes = classes
                    showIndicator = false
                    print("DEBUG: Fetched Class Table Successfully.")
                    
                case .failure(let error):
                    showIndicator = false
                    print("DEBUG: Fetching Class Table Failed With Error: \(String(describing: error)), using local data.")
                    
                    if let local = ClassTableManager.shared.fromLocal() {
                        observable.classes = local
                        print("DEBUG: Used Local Data.")
                    } else {
                        presentAlert = true
                    }
                }
            }
        }
        .onDisappear {
            colorHash = Array(repeating: nil, count: 20)
        }
    }
    
    
    func selectColor(with className: String) -> UIColor? {
        guard !className.isEmpty else { return nil }
        
        var unicode = abs(Int(className.first!.unicodeScalars.map({ $0.value }).reduce(0, +)) % 20)
        
        while colorHash[unicode] != nil && colorHash[unicode] != className {
            unicode = (unicode + 1) % 20
        }
        
        colorHash[unicode] = className
        
        return UIColor(hex: colorSet[unicode])
    }
}

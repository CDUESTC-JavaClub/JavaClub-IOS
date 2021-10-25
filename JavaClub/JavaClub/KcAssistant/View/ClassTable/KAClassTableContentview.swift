//
//  KAClassTableContentview.swift
//  JavaClub
//
//  Created by Roy on 2021/10/15.
//

import UIKit
import SwiftUI
import ExyteGrid
import Defaults

struct KAClassTableContentview: View {
    @Default(.classTableTerm) var term
    @State var presentAlert = false
    @ObservedObject private var observable: KAClassTableObservable = .shared
    
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
        GeometryReader { geo in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(1 ..< 8) { index in
                        switch index {
                        case 1:
                            Text("周一")
                                .frame(width: geo.size.width / 7, height: 30)
                                .background(Color(hex: "60D1AE"))

                        case 2:
                            Text("周二")
                                .frame(width: geo.size.width / 7, height: 30)
                                .background(Color(hex: "60D1AE"))

                        case 3:
                            Text("周三")
                                .frame(width: geo.size.width / 7, height: 30)
                                .background(Color(hex: "60D1AE"))

                        case 4:
                            Text("周四")
                                .frame(width: geo.size.width / 7, height: 30)
                                .background(Color(hex: "60D1AE"))

                        case 5:
                            Text("周五")
                                .frame(width: geo.size.width / 7, height: 30)
                                .background(Color(hex: "60D1AE"))

                        case 6:
                            Text("周六")
                                .frame(width: geo.size.width / 7, height: 30)
                                .background(Color(hex: "60D1AE"))

                        case 7:
                            Text("周日")
                                .frame(width: geo.size.width / 7, height: 30)
                                .background(Color(hex: "60D1AE"))

                        default:
                            Text("")
                                .frame(width: geo.size.width / 7, height: 30)
                                .background(Color(hex: "60D1AE"))
                        }
                    }
                }
                
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(observable.classes, id: \.id) {
                            KAClassTableCell(className: $0.name, location: $0.locale, teacher: $0.teacher, color: Color(selectColor(with: $0.name) ?? .gray))
                                .frame(height: 150)
                        }
//                        ForEach(0 ..< 35) {_ in
//                            Color.blue.frame(height: 150).padding(.bottom, 10)
//                        }
                    }
                }
                .padding(.top, 10)
            }
        }
        .alert(isPresented: $presentAlert) {
            Alert(title: Text("错误"), message: Text("暂无法获取该学期课表，请稍后再试。"), dismissButton: .default(Text("Got it!")))
        }
        .onAppear {
            JCAccountManager.shared.getClassTable(term: term) { result in
                switch result {
                case .success(let classes):
                    observable.classes = classes
                    print("DEBUG: Fetched Class Table Successfully.")
                    
                case .failure(let error):
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
    }
    
    
    func selectColor(with className: String) -> UIColor? {
        guard !className.isEmpty else { return nil }
        
        var unicode = abs(Int(className.first!.unicodeScalars.map({ $0.value }).reduce(0, +)) % 20)
        
        while observable.colorHash[unicode] != nil && observable.colorHash[unicode] != className {
            unicode = (unicode + 1) % 20
        }
        
        observable.colorHash[unicode] = className
        
        return UIColor(hex: observable.colorSet[unicode])
    }
}

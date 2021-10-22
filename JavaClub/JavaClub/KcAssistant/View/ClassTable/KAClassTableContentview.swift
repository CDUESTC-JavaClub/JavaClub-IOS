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
    @State var _class: [KAClass] = []
    @State var presentAlert = false
    @ObservedObject private var colorSelector: KAClassTableColorSelector = .shared
    
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Grid(1 ..< 8, tracks: 7, flow: .rows) {
                    Text("周\($0)")
                        .frame(width: geo.size.width / 7, height: 50)
                        .background(Color.orange)
                }
                .frame(height: 50)
                
                Grid(_class, tracks: 5, flow: .columns) {
                    #warning("Infinite Loop")
                    KAClassTableCell(className: $0.name, location: $0.locale, teacher: $0.teacher, color: Color(selectColor(with: $0.name) ?? .systemBlue))
                }
            }
        }
        .alert(isPresented: $presentAlert) {
            Alert(title: Text("错误"), message: Text("暂无法获取该学期课表，请稍后再试。"), dismissButton: .default(Text("Got it!")))
        }
        .onAppear {
            JCAccountManager.shared.getClassTable(term: term) { result in
                switch result {
                case .success(let classes):
                    _class = classes
                    print("DEBUG: Fetched Class Table Successfully.")
                    
                case .failure(let error):
                    print("DEBUG: Fetching Class Table Failed With Error: \(String(describing: error)), using local data.")
                    
                    if let local = ClassTableManager.shared.fromLocal() {
                        _class = local
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
        
        while colorSelector.colorHash[unicode] != nil && colorSelector.colorHash[unicode] != className {
            unicode = (unicode + 1) % 20
        }
        
        colorSelector.colorHash[unicode] = className
        
        return UIColor(hex: colorSelector.colorSet[unicode])
    }
}

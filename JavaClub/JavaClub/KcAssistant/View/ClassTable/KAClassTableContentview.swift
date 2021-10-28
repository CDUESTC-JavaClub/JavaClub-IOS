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
    @State var showTermSelector = false
    @State var showClassDetail = false
    
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
                            showTermSelector = true
                        } label: {
                            HStack(spacing: 0) {
                                Text(JCDateManager.shared.formatted(for: term) ?? "获取失败...")
                                
                                Image(systemName: "chevron.down")
                                    .renderingMode(.template)
                            }
                        }
                    }
                    .padding(.bottom, 10)
                    
                    HStack(spacing: 0) {
                        ForEach(1 ..< 8) { index in
                            Text("周\(index.chinese ?? "\(index)")")
                                .frame(width: geo.size.width / 7, height: 30)
                                .foregroundColor(.white)
                                .background(Color(hex: "413258"))
                        }
                    }
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(observable.classes, id: \.id) {
                                KAClassTableCell(
                                    className: $0.name,
                                    location: $0.locale,
                                    teacher: $0.teacher,
                                    form: $0.form,
                                    color: Color(selectColor(with: $0.name) ?? .gray)
                                )
                                .frame(height: 150)
                                .padding(.top, 5)
                            }
                        }
                    }
                }
            }
            
            if showTermSelector {
                GeometryReader { geo in
                    KATermSelectorView(isShown: $showTermSelector, selected: $term)
                        .position(x: geo.size.width / 2, y: geo.size.height / 2)
                }
                .background(
                    Color.black
                        .opacity(0.45)
                        .edgesIgnoringSafeArea(.all)
                )
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
            refresh(for: term)
        }
        .onDisappear {
            colorHash = Array(repeating: nil, count: 20)
        }
        .onChange(of: term) { newValue in
            refresh(for: newValue)
        }
    }
    
    func refresh(for term: Int) {
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

//
//  ContentView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/8/30.
//

import SwiftUI

struct ContentView: View {
    @State var selected: Tab = .club
    @State var centerX: CGFloat = 0
    
    init() {
        UITabBar.appearance().isHidden = true
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                TabView(selection: $selected) {
                    
                    JCContentView()
                        .tag(Tab.club)
                    
                    KAContentView()
                        .tag(Tab.kc)
                        .edgesIgnoringSafeArea(.top)
                    
                    BAContentView()
                        .tag(Tab.bai)
                        .edgesIgnoringSafeArea(.top)
                    
                    STContentView()
                        .tag(Tab.settings)
                }
                
                TabBarView(selected: $selected, centerX: $centerX)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

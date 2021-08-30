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
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                TabView(selection: $selected) {
                    
                    JCContentView()
                        .navigationBarTitle("JavaClub", displayMode: .large)
                        .tag(Tab.club)
                    
                    
                    NavigationView {
                        KAContentView()
                            .navigationBarTitle("教务", displayMode: .large)
                    }
                    .tag(Tab.kc)
                    .edgesIgnoringSafeArea(.top)
                    
                    NavigationView {
                        BAContentView()
                            .navigationBarTitle("百叶计划", displayMode: .large)
                    }
                    .tag(Tab.bai)
                    .edgesIgnoringSafeArea(.top)
                    
                    NavigationView {
                        SettingsContentView()
                            .navigationBarTitle("设置", displayMode: .large)
                    }
                    .tag(Tab.settings)
                    .edgesIgnoringSafeArea(.top)
                }
                
                TabBarView(selected: $selected, centerX: $centerX)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

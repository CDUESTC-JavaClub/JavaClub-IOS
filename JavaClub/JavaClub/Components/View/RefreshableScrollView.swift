//
//  RefreshableScrollView.swift
//  JavaClub
//
//  Created by Roy on 2021/10/8.
//

import SwiftUI

struct RefreshableScrollView<Content:View>: View {
    private var content: () -> Content
    private var refreshAction: () -> Void
    private let threshold:CGFloat = 50.0
    
    init(action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.refreshAction = action
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                content()
                    .anchorPreference(key: OffsetPreferenceKey.self, value: .top) {
                        geometry[$0].y
                    }
            }
            .onPreferenceChange(OffsetPreferenceKey.self) { offset in
                if offset > threshold {
                    refreshAction()
                }
            }
        }
    }
}


struct RefreshableScrollViewModifier: ViewModifier {
    var action: () -> Void

    func body(content: Content) -> some View {
        RefreshableScrollView(action: action) {
            content
        }
    }
}


fileprivate struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

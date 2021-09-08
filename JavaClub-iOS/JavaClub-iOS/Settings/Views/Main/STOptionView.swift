//
//  STOptionView.swift
//  JavaClub-iOS
//
//  Created by Roy Rao on 2021/9/7.
//

import SwiftUI
import Defaults

struct STOptionView: View {
    @Default(.useDarkMode) private var useDarkMode: Bool
    @Default(.useSystemAppearance) private var useSystemAppearance: Bool
    
    var body: some View {
        Section(header: Text("设置")) {
            Toggle(isOn: $useDarkMode) {
                Text("使用深色模式")
            }
            .disabled(useSystemAppearance)
            
            Toggle(isOn: $useSystemAppearance) {
                Text("主题外观跟随系统")
            }
            .valueChanged(value: useSystemAppearance) { newValue in
                if newValue {
                    useDarkMode = newValue
                }
            }
        }
    }
}

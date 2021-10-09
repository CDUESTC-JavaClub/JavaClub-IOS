//
//  SettingsOption.swift
//  JavaClub
//
//  Created by Roy on 2021/9/27.
//

import UIKit

enum STOptionType {
    case tappable(model: STTappableOption)
    case switchable(model: STSwitchOption)
    case _static(model: STStaticOption)
}


struct STTappableOption {
    let title: String
    let icon: UIImage?
    let handler: () -> Void
}


struct STSwitchOption {
    let title: String
    let icon: UIImage?
    var isOn: Bool
    var isEnabled: Bool
    let handler: (UISwitch) -> Void
}

struct STStaticOption {
    let title: String
    let icon: UIImage?
    var value: String
}

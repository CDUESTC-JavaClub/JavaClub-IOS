//
//  SettingsOption.swift
//  JavaClub
//
//  Created by Roy on 2021/9/27.
//

import UIKit

enum TVOptionType {
    case tappable(model: TVTappableOption)
    case switchable(model: TVSwitchOption)
    case _static(model: TVStaticOption)
}


struct TVTappableOption {
    let title: String
    let icon: UIImage?
    let handler: () -> Void
}


struct TVSwitchOption {
    let title: String
    let icon: UIImage?
    var isOn: Bool
    var isEnabled: Bool
    let handler: (UISwitch) -> Void
}

struct TVStaticOption {
    let title: String
    let icon: UIImage?
    var value: String
}

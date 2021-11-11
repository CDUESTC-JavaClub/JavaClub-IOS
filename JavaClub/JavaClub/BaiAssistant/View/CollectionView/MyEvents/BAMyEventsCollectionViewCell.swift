//
//  BAMyEventsCollectionViewCell.swift
//  JavaClub
//
//  Created by Roy on 2021/11/11.
//

import UIKit

class BAMyEventsCollectionViewCell: UICollectionViewCell {
    var item: BAEvent?
    
    @available(iOS 13.0, *)
    var osTheme: UIUserInterfaceStyle {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var bgConfig = UIBackgroundConfiguration.listGroupedCell()
        bgConfig.backgroundColor = osTheme == .light ? UIColor(hex: "FFFFFF") : UIColor(hex: "1C1C1E")
        backgroundConfiguration = bgConfig
        
        var newConfig = BAMyEventsContentConfiguration().updated(for: state)
        
        if let item = item {
            newConfig.title = item.eventName
            newConfig.time = item.startDate.formatted()
            newConfig.location = item.place
            let iconResult = selectIcon(for: item.type)
            newConfig.typeIcon = iconResult.0
            newConfig.tintColor = iconResult.1
            newConfig.type = selectType(for: item.type)
        }
        
        contentConfiguration = newConfig
    }
}


fileprivate extension BAMyEventsCollectionViewCell {
    
    private func selectType(for rawType: String) -> String {
        switch rawType {
            case "md":
                return "明德"
            
            case "dx":
                return "笃行"
            
            case "jm":
                return "尽美"
            
            case "bx":
                return "博学"
            
            default:
                return ""
        }
    }
    
    private func selectIcon(for type: String) -> (UIImage?, UIColor) {
        switch type {
            case "md":
                let img = UIImage(named: "bai_icon_md")
                return (img, UIColor(hex: "A54E44") ?? .systemRed)
            
            case "dx":
                let img = UIImage(named: "bai_icon_dx")
                return (img, UIColor(hex: "769A6A") ?? .systemGreen)
            
            case "jm":
                let img = UIImage(named: "bai_icon_jm")
                return (img, UIColor(hex: "E8CB76") ?? .systemYellow)
            
            case "bx":
                let img = UIImage(named: "bai_icon_bx")
                return (img, UIColor(hex: "648EC1") ?? .systemBlue)
            
            default:
                return (nil, .clear)
        }
    }
}

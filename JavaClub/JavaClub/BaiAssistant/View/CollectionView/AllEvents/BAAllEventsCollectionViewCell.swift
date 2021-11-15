//
//  BAAllEventsCollectionViewCell.swift
//  JavaClub
//
//  Created by Roy on 2021/11/8.
//

import UIKit
import Kingfisher

class BAAllEventsCollectionViewCell: UICollectionViewListCell {
    var item: BAEvent?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfig = BAAllEventsContentConfiguration().updated(for: state)
        
        if let item = item {
            newConfig.title = item.eventName
            JCImageManager.shared.fetch(from: item.coverUrl) { result in
                DispatchQueue.main.async {
                    newConfig.eventIcon = result?.image ?? UIImage(named: "event_holder")
                }
            }
            newConfig.time = item.startDate.formatted()
            newConfig.location = item.place
            let iconResult = selectIcon(for: item.type)
            newConfig.typeIcon = iconResult.0
            newConfig.tintColor = iconResult.1
            newConfig.type = selectType(for: item.type)
            let statusResult = selectStatus(for: item.status)
            newConfig.status = statusResult.0
            newConfig.statusLabelColor = statusResult.1
        }
        
        contentConfiguration = newConfig
    }
}


fileprivate extension BAAllEventsCollectionViewCell {
    
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
    
    private func selectStatus(for status: Int) -> (String, UIColor) {
        
        switch status {
            case 4:
                return ("报名中", .systemGreen)
            
            case 5:
                return ("报名结束", .systemRed)
            
            case 7:
                return ("活动中", .systemYellow)
                
            case 8:
                return ("已结束", .lightGray)
            
            default:
                return ("未知", .label)
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

//
//  BAMyCreditsCollectionViewCell.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/11/15.
//

import UIKit

class BAMyCreditsCollectionViewCell: UICollectionViewCell {
    var item: BAScoreAdding?
    
    @available(iOS 13.0, *)
    var osTheme: UIUserInterfaceStyle {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var bgConfig = UIBackgroundConfiguration.listGroupedCell()
        bgConfig.backgroundColor = osTheme == .light ? UIColor(hex: "FFFFFF") : UIColor(hex: "1C1C1E")
        backgroundConfiguration = bgConfig
        
        var newConfig = BAMyCreditsContentConfiguration().updated(for: state)
        
        if let item = item {
            newConfig.title = item.eventName
            newConfig.reason = item.reason
            newConfig.score = "+\(item.score)"
            newConfig.type = selectType(for: item.type)
        }
        
        contentConfiguration = newConfig
    }
}


fileprivate extension BAMyCreditsCollectionViewCell {
    
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
}

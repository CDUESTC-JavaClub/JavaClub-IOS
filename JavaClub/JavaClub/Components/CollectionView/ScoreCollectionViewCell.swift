//
//  ScoreCollectionViewCell.swift
//  JavaClub
//
//  Created by Roy on 2021/10/12.
//

import UIKit
import SnapKit

class ScoreCollectionViewCell: UICollectionViewCell {
    var item: KAScore?
    
    @available(iOS 13.0, *)
    var osTheme: UIUserInterfaceStyle {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var bgConfig = UIBackgroundConfiguration.listGroupedCell()
        bgConfig.backgroundColor = osTheme == .light ? UIColor(hex: "FFFFFF") : UIColor(hex: "1C1C1E")
        backgroundConfiguration = bgConfig
        
        var config = CVScoreContentConfiguration().updated(for: state)
        
        if let item = item {
            config.title = item.className
            config.detail = "学分 \(item.points) (绩点 \(item.credits))"
            
            let score = item.redoScore > item.score ? item.redoScore : item.score
            config.icon = makeScoreImage(score: score)
            config.score = score
        }
        
        contentConfiguration = config
    }
}


extension ScoreCollectionViewCell {
    
    
    private func makeScoreImage(score: Double) -> UIImage {
        let bgColor: UIColor!
        
        switch score {
        case 0 ..< 60:
            bgColor = UIColor(hex: "DC143C")
            
        case 60 ..< 70:
            bgColor = UIColor(hex: "FF8C00")
            
        case 70 ..< 80:
            bgColor = UIColor(hex: "BA55D3")
            
        case 80 ..< 90:
            bgColor = UIColor(hex: "1E90FF")
            
        case 90 ... 100:
            bgColor = UIColor(hex: "32CD32")
            
        default:
            bgColor = UIColor(hex: "DC143C")
        }
        
        return UIImage.fromColor(bgColor)
    }
}

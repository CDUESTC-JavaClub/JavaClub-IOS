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
//            retrieveImage(for: item.coverUrl) { img in
//                DispatchQueue.main.async {
//                    newConfig.eventIcon = img
//                }
//            }
            #warning("Image Placeholder")
            newConfig.eventIcon = UIImage(named: "img_placeholder")
            newConfig.time = item.startDate.formatted()
            newConfig.location = item.place
            newConfig.typeIcon = selectIcon(for: item.type)
            newConfig.type = item.type
            newConfig.status = item.status
        }
        
        contentConfiguration = newConfig
    }
    
    private func retrieveImage(for urlStr: String, _ completion: @escaping (UIImage?) -> Void) {
        guard let imgURL = URL(string: urlStr) else {
            completion(UIImage(named: "event_holder"))
            return
        }
        
        ImageDownloader.default.downloadImage(with: imgURL) { result in
            switch result {
            case .success(let data):
                completion(data.image)
                
            case .failure(let error):
                print("DEBUG: Fetch Event Image Failed With Error: \(String(describing: error))")
            }
        }
    }
    
    private func selectIcon(for type: String) -> UIImage? {
        switch type {
        case "md":
            return UIImage(named: "bai_icon_md")?.withTintColor(UIColor(hex: "A54E44") ?? .systemRed)
            
        case "dx":
            return UIImage(named: "bai_icon_dx")?.withTintColor(UIColor(hex: "769A6A") ?? .systemGreen)
            
        case "jm":
            return UIImage(named: "bai_icon_jm")?.withTintColor(UIColor(hex: "E8CB76") ?? .systemYellow)
            
        case "bx":
            return UIImage(named: "bai_icon_bx")?.withTintColor(UIColor(hex: "648EC1") ?? .systemBlue)
            
        default:
            return nil
        }
    }
}

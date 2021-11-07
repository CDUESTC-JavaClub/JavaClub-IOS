//
//  CVScoreContentConfiguration.swift
//  JavaClub
//
//  Created by Roy on 2021/10/14.
//

import UIKit

struct CVScoreContentConfiguration: UIContentConfiguration, Hashable {
    var title: String?
    var detail: String?
    var score: Double?
    var icon: UIImage?
    
    func makeContentView() -> UIView & UIContentView {
        CVScoreContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
//        guard let state = state as? UICellConfigurationState else {
//            return self
//        }
        
        // Pending Configurations
        
        return self
    }
}

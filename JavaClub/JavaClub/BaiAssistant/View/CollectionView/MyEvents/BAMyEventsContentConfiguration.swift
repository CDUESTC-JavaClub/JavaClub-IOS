//
//  BAMyEventsContentConfiguration.swift
//  JavaClub
//
//  Created by Roy on 2021/11/8.
//

import UIKit

struct BAMyEventsContentConfiguration: UIContentConfiguration, Hashable {
    var title: String?
    var time: String?
    var location: String?
    var typeIcon: UIImage?
    var tintColor: UIColor!
    var type: String?
    
    func makeContentView() -> UIView & UIContentView {
        BAMyEventsContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> BAMyEventsContentConfiguration {
        self
    }
}

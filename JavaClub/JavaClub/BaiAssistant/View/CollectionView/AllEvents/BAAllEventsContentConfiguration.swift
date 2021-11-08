//
//  BAAllEventsContentConfiguration.swift
//  JavaClub
//
//  Created by Roy on 2021/11/8.
//

import UIKit

struct BAAllEventsContentConfiguration: UIContentConfiguration, Hashable {
    var eventIcon: UIImage?
    var title: String?
    var time: String?
    var location: String?
    var typeIcon: UIImage?
    var type: String?
    var status: String?
    
    func makeContentView() -> UIView & UIContentView {
        return BAAllEventsContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> BAAllEventsContentConfiguration {
        self
    }
}

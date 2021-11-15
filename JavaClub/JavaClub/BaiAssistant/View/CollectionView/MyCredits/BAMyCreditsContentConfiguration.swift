//
//  BAMyCreditsContentConfiguration.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/11/15.
//

import UIKit

struct BAMyCreditsContentConfiguration: UIContentConfiguration, Hashable {
    var title: String?
    var reason: String?
    var score: String?
    var type: String?
    
    func makeContentView() -> UIView & UIContentView {
        BAMyCreditsContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> BAMyCreditsContentConfiguration {
        self
    }
}

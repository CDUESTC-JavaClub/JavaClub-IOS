//
//  BAMyEventsContentView.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/11/6.
//

import UIKit
import SnapKit

class BAMyEventsContentView: UIView, UIContentView {
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeIconView: UIImageView!
    @IBOutlet var typeLabel: UILabel!
    
    private var currentConfiguration: BAMyEventsContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        
        set {
            guard let newConfig = newValue as? BAMyEventsContentConfiguration else {
                return
            }
            
            apply(configuration: newConfig)
        }
    }
    
    
    init(configuration: BAMyEventsContentConfiguration) {
        super.init(frame: .zero)
        
        loadNib()
        
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension BAMyEventsContentView {
    
    private func loadNib() {
        Bundle.main.loadNibNamed("\(BAMyEventsContentView.self)", owner: self, options: nil)
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func apply(configuration: BAMyEventsContentConfiguration) {
        guard configuration != currentConfiguration else { return }
        
        currentConfiguration = configuration
        
        titleLabel.text = configuration.title
        timeLabel.text = configuration.time
        locationLabel.text = configuration.location
        typeIconView.image = configuration.typeIcon
        typeIconView.tintColor = configuration.tintColor
        typeLabel.text = configuration.type
    }
}

//
//  BAAllEventsContentView.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/11/6.
//

import UIKit
import SnapKit

class BAAllEventsContentView: UIView, UIContentView {
    @IBOutlet var containerView: UIView!
    @IBOutlet var eventIconView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeIconView: UIImageView!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    private var currentConfiguration: BAAllEventsContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        
        set {
            guard let newConfig = newValue as? BAAllEventsContentConfiguration else {
                return
            }
            
            apply(configuration: newConfig)
        }
    }
    
    
    init(configuration: BAAllEventsContentConfiguration) {
        super.init(frame: .zero)
        
        loadNib()
        
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension BAAllEventsContentView {
    
    private func loadNib() {
        Bundle.main.loadNibNamed("\(BAAllEventsContentView.self)", owner: self, options: nil)
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func apply(configuration: BAAllEventsContentConfiguration) {
        guard configuration != currentConfiguration else { return }
        
        currentConfiguration = configuration
        
        eventIconView.image = configuration.eventIcon
        titleLabel.text = configuration.title
        timeLabel.text = configuration.time
        locationLabel.text = configuration.location
        typeIconView.image = configuration.typeIcon
        typeIconView.tintColor = configuration.tintColor
        typeLabel.text = configuration.type
        statusLabel.text = "（\(configuration.status ?? "未知")）"
        statusLabel.textColor = configuration.statusLabelColor
    }
}

//
//  BAMyCreditsContentView.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/11/15.
//

import UIKit
import SnapKit

class BAMyCreditsContentView: UIView, UIContentView {
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var reasonLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
    private var currentConfiguration: BAMyCreditsContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        
        set {
            guard let newConfig = newValue as? BAMyCreditsContentConfiguration else {
                return
            }
            
            apply(configuration: newConfig)
        }
    }
    
    
    init(configuration: BAMyCreditsContentConfiguration) {
        super.init(frame: .zero)
        
        loadNib()
        
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension BAMyCreditsContentView {
    
    private func loadNib() {
        Bundle.main.loadNibNamed("\(BAMyCreditsContentView.self)", owner: self, options: nil)
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func apply(configuration: BAMyCreditsContentConfiguration) {
        guard configuration != currentConfiguration else { return }
        
        currentConfiguration = configuration
        
        titleLabel.text = configuration.title
        reasonLabel.text = configuration.reason
        scoreLabel.text = configuration.score
        typeLabel.text = configuration.type
    }
}

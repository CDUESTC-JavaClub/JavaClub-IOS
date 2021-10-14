//
//  CVScoreContentView.swift
//  JavaClub
//
//  Created by Roy on 2021/10/14.
//

import UIKit
import SnapKit

class CVScoreContentView: UIView, UIContentView {
    
    @available(iOS 13.0, *)
    var osTheme: UIUserInterfaceStyle {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
    
    private let iconImageView: ScoreImageView = {
        let view = ScoreImageView()
        view.tintColor = .label
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        
        return label
    }()
    
    private var currentConfiguration: CVScoreContentConfiguration!
    
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        
        set {
            guard let newConfig = newValue as? CVScoreContentConfiguration else {
                return
            }
            
            apply(configuration: newConfig)
        }
    }
    
    
    init(configuration: CVScoreContentConfiguration) {
        super.init(frame: .zero)
        
        setup()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension CVScoreContentView {
    
    private func setup() {
        let vStackView = UIStackView()
        vStackView.axis = .vertical
        vStackView.alignment = .leading
        vStackView.distribution = .fill
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let hStackView = UIStackView()
        hStackView.axis = .horizontal
        hStackView.alignment = .fill
        hStackView.distribution = .fillProportionally
        hStackView.spacing = 10
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStackView)
        
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(detailLabel)
        
        hStackView.addArrangedSubview(iconImageView)
        hStackView.addArrangedSubview(vStackView)
        
        hStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.greaterThanOrEqualToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
    }
    
    private func apply(configuration: CVScoreContentConfiguration) {
        guard currentConfiguration != configuration else {
            return
        }
        
        currentConfiguration = configuration
        
        iconImageView.label.text = "\(configuration.score ?? 0)"
        iconImageView.image = configuration.icon

        titleLabel.text = configuration.title
        titleLabel.textColor = osTheme == .light ? .darkText : .lightText
        titleLabel.font = .systemFont(ofSize: 14)
        
        detailLabel.text = configuration.detail
        detailLabel.textColor = osTheme == .light ? .darkText : .lightText
        detailLabel.font = .systemFont(ofSize: 11)
    }
}

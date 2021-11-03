//
//  ProgressIndicator.swift
//  JavaClub
//
//  Created by Roy on 2021/11/3.
//

import UIKit
import SnapKit

// MARK: For UIKit -
class ProgressIndicator: UIView {
    var foregroundColor: UIColor = .white {
        didSet {
            bgView.backgroundColor = foregroundColor
        }
    }
    
    private let bgView: UIView = {
        let aView = UIView(frame: .zero)
        aView.backgroundColor = .white
        aView.layer.cornerRadius = 15
        return aView
    }()
    
    private let hintLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "加载中".localized()
        label.textColor = .label
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let spinner: ProgressView = {
        let progress = ProgressView(
            colors: [UIColor(hex: "BB85E9") ?? .purple, UIColor(hex: "60D1AE") ?? .systemGreen],
            lineWidth: 5
        )
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ProgressIndicator {
    
    private func setup() {
        backgroundColor = .black.withAlphaComponent(0.45)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bgView)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.centerY.equalToSuperview()
        }
        
        bgView.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
        }
        
        bgView.addSubview(hintLabel)
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func resume() {
        spinner.isAnimating = true
    }
    
    func stop() {
        spinner.isAnimating = false
    }
}

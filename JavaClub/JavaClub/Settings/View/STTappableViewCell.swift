//
//  STTableViewCell.swift
//  JavaClub
//
//  Created by Roy on 2021/10/9.
//

import UIKit

class STTappableViewCell: UITableViewCell {
    static let identifier = "STTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}


extension STTappableViewCell {
    
    func configure(with model: STTappableOption) {
        
        var configuration = defaultContentConfiguration()
        configuration.image = model.icon
        configuration.imageProperties.maximumSize = CGSize(width: 25, height: 25)
        configuration.imageProperties.cornerRadius = 8
        configuration.text = model.title
        configuration.textProperties.color = .label
        configuration.textProperties.font = .systemFont(ofSize: 14)
        
        contentConfiguration = configuration
    }
}

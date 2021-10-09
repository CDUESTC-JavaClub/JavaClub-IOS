//
//  STTableViewCell.swift
//  JavaClub
//
//  Created by Roy on 2021/10/9.
//

import UIKit

class STTappableViewCell: UITableViewCell {
    static let identifier = "STTableViewCell"
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size: CGFloat = contentView.frame.size.height - 12
        iconImageView.frame = CGRect(x: 15, y: 6, width: size, height: size)
        
        label.frame = CGRect(
            x: 25 + iconImageView.frame.size.width,
            y: 0,
            width: contentView.frame.size.width - 20 - iconImageView.frame.size.width,
            height: contentView.frame.size.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        iconImageView.image = nil
    }
}


extension STTappableViewCell {
    
    func configure(with model: STTappableOption) {
        var configuration = defaultContentConfiguration()
        configuration.text = model.title
        configuration.image = model.icon
        configuration.textProperties.color = .label
        
        contentConfiguration = configuration
    }
}

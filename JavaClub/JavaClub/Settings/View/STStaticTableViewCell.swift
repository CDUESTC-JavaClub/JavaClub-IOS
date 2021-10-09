//
//  STStaticTableViewCell.swift
//  JavaClub
//
//  Created by Roy on 2021/10/9.
//

import UIKit

class STStaticTableViewCell: UITableViewCell {
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
    
    private let value: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.addSubview(value)
        contentView.clipsToBounds = true
        accessoryType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size: CGFloat = contentView.frame.size.height - 12
        iconImageView.frame = CGRect(x: 15, y: 6, width: size, height: size)
        
        value.sizeToFit()
        value.frame = CGRect(
            x: contentView.frame.size.width - value.frame.size.width - 20,
            y: (contentView.frame.size.height - value.frame.size.height) / 2,
            width: value.frame.size.width,
            height: value.frame.size.height
        )
        
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
        value.text = nil
    }
}


extension STStaticTableViewCell {
    
    func configure(with model: STStaticOption) {
        selectionStyle = .none
        isUserInteractionEnabled = false
        
        var configuration = defaultContentConfiguration()
        configuration.text = model.title
        configuration.image = model.icon
        value.text = model.value
        
        contentConfiguration = configuration
    }
}

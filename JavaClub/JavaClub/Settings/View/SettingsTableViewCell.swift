//
//  SettingsTableViewCell.swift
//  JavaClub
//
//  Created by Roy on 2021/9/27.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "settingsTableViewCell"
    
    private let iconContainer: UIView = {
       let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let iconImageView: UIImageView = {
       let imgView = UIImageView()
        imgView.tintColor = .white
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(iconContainer)   // 1
        iconContainer.addSubview(iconImageView)    // 2
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size: CGFloat = contentView.frame.height - 12
        iconImageView.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        let imageSize: CGFloat = size / 1.5
        iconImageView.frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        iconImageView.center = iconContainer.center
        
        label.frame = CGRect(
            x: 15 + iconContainer.frame.width,
            y: 0,
            width: contentView.frame.width - 15 - iconContainer.frame.width,
            height: contentView.frame.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImageView.image = nil
        label.text = nil
        iconContainer.backgroundColor = nil
    }
}


extension SettingsTableViewCell {
    
    public func configure(with model: SettingsOption) {
        label.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
    }
}

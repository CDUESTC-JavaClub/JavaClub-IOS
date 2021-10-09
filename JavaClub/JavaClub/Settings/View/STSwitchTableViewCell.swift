//
//  STSwitchTableViewCell.swift
//  JavaClub
//
//  Created by Roy on 2021/10/9.
//

import UIKit

class STSwitchTableViewCell: UITableViewCell {
    static let identifier = "STSwitchTableViewCell"
    
    private var cellModel: STSwitchOption!
    
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
    
    private let _switch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.onTintColor = .systemBlue
        
        return mySwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.addSubview(_switch)
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
        
        _switch.sizeToFit()
        _switch.frame = CGRect(
            x: contentView.frame.size.width - _switch.frame.size.width - 20,
            y: (contentView.frame.size.height - _switch.frame.size.height) / 2,
            width: _switch.frame.size.width,
            height: _switch.frame.size.height
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
        _switch.isOn = false
    }
}


extension STSwitchTableViewCell {
    
    func configure(with model: STSwitchOption) {
        selectionStyle = .none
        isUserInteractionEnabled = false
        
        cellModel = model
        
        var configuration = defaultContentConfiguration()
        configuration.text = model.title
        configuration.textProperties.color = .label
        configuration.image = model.icon
        
        _switch.isOn = model.isOn
        _switch.addTarget(self, action: #selector(switchDidToggle(_:)), for: .valueChanged)
        
        contentConfiguration = configuration
    }
    
    @IBAction func switchDidToggle(_ sender: UISwitch) {
        cellModel.handler(sender)
    }
}

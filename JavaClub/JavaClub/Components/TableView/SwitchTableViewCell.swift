//
//  SwitchTableViewCell.swift
//  JavaClub
//
//  Created by Roy on 2021/10/9.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    static let identifier = "SwitchTableViewCell"
    
    private var cellModel: TVSwitchOption!
    
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
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).inset(20)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        _switch.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).inset(20)
            make.leading.equalTo(label.snp.trailing)
            make.centerY.equalTo(label.snp.centerY)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        iconImageView.image = nil
        _switch.isOn = false
    }
}


extension SwitchTableViewCell {
    
    func configure(with model: TVSwitchOption, completion: (UISwitch) -> Void) {
        selectionStyle = .none
        
        cellModel = model
        
        label.text = model.title
        label.textColor = .label
        label.font = .systemFont(ofSize: 14)
        
        _switch.onTintColor = UIColor(hex: "60D1AE")
        _switch.isOn = model.isOn
        _switch.addTarget(self, action: #selector(switchDidToggle(_:)), for: .valueChanged)
        
        completion(_switch)
    }
    
    @IBAction func switchDidToggle(_ sender: UISwitch) {
        cellModel.handler(sender)
    }
}

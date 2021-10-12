//
//  TVStaticTableViewCell.swift
//  JavaClub
//
//  Created by Roy on 2021/10/9.
//

import UIKit
import SnapKit

class TVStaticTableViewCell: UITableViewCell {
    static let identifier = "STStaticTableViewCell"
    
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
        label.baselineAdjustment = .alignCenters
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.addSubview(value)
        contentView.clipsToBounds = true
        accessoryType = .none
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).inset(20)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        value.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).inset(20)
            make.leading.equalTo(label.snp.trailing)
            make.centerY.equalTo(label.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        iconImageView.image = nil
        value.text = nil
    }
}


extension TVStaticTableViewCell {
    
    func configure(with model: TVStaticOption) {
        selectionStyle = .none
        isUserInteractionEnabled = false
        
        label.text = model.title
        label.textColor = .label
        label.font = .systemFont(ofSize: 14)
        value.text = model.value
        value.textColor = .secondaryLabel
        value.font = .systemFont(ofSize: 14)
    }
}

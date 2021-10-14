//
//  ScoreImageView.swift
//  JavaClub
//
//  Created by Roy on 2021/10/14.
//

import UIKit
import SnapKit

class ScoreImageView: UIImageView {
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

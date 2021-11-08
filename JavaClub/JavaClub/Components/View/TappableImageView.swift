//
//  TappableImageView.swift
//  JavaClub
//
//  Created by Roy on 2021/11/8.
//

import UIKit

class TappableImageView: UIImageView {
    var onTapGesture: (() -> Void)?
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }
    
    
    @objc private func tapped() {
        onTapGesture?()
    }
}

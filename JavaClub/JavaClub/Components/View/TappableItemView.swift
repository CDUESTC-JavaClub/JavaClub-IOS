//
//  TappableItemView.swift
//  JavaClub
//
//  Created by Roy on 2021/10/8.
//

import UIKit

class TappableItemView: UIControl {
    var didTap: (() -> Void)?
    var normalColor: UIColor? = .systemBackground
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        backgroundColor = .gray.withAlphaComponent(0.2)
        
        return super.beginTracking(touch, with: event)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        backgroundColor = normalColor
        
        super.endTracking(touch, with: event)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if bounds.contains(point) {
            backgroundColor = .gray.withAlphaComponent(0.2)
            didTap?()
            
            return self
        } else {
            return super.hitTest(point, with: event)
        }
    }
}

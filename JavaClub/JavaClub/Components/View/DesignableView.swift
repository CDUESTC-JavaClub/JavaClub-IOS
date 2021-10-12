//
//  DesignableView.swift
//  JavaClub
//
//  Created by Roy Rao on 2021/9/25.
//

import UIKit

@IBDesignable
class DesignableView: UIView {
    var isDark: Bool? {
        didSet {
            backgroundColor = isDark == true ? darkColor : lightColor
        }
    }
    
    @IBInspectable var lightColor: UIColor?
    @IBInspectable var darkColor: UIColor?
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
}

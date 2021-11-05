//
//  TappableButton.swift
//  JavaClub
//
//  Created by Roy on 2021/11/4.
//

import UIKit

@IBDesignable
class TappableButton: UIButton {
    @IBInspectable var normalColor: UIColor = .clear
    @IBInspectable var highlightedColor: UIColor = .clear
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightedColor : normalColor
        }
    }
}

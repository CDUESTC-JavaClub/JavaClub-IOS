//
//  UnderlineButton.swift
//  JavaClub
//
//  Created by Roy on 2021/10/12.
//

import UIKit

@IBDesignable
class UnderlineButton: UIButton {
    @IBInspectable var titleString: String!
    @IBInspectable var titleStringColor: UIColor?
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        setAttributedTitle(
            NSAttributedString(string: titleString, attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: titleStringColor ?? .label
            ]),
            for: .normal
        )
    }
}

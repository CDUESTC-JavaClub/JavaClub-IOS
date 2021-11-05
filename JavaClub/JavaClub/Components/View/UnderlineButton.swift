//
//  UnderlineButton.swift
//  JavaClub
//
//  Created by Roy on 2021/10/12.
//

import UIKit

@IBDesignable
class UnderlineButton: UIButton {
    
    @IBInspectable var localizedKey: String? {
        didSet {
            guard let key = localizedKey else { return }
            setTitle(NSLocalizedString(key, comment: ""), for: .normal)
        }
    }
    
    @IBInspectable var titleString: String!
    @IBInspectable var titleStringColor: UIColor?
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        setAttributedTitle(
            NSAttributedString(string: titleString.localized(), attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .foregroundColor: titleStringColor ?? .label
            ]),
            for: .normal
        )
    }
}

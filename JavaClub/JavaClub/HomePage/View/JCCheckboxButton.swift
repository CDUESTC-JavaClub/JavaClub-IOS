//
//  JCCheckboxButton.swift
//  JavaClub
//
//  Created by Roy on 2021/10/11.
//

import UIKit

@IBDesignable
class JCCheckboxButton: UIButton {
    
    @IBInspectable var localizedKey: String? {
        didSet {
            guard let key = localizedKey else { return }
            setTitle(NSLocalizedString(key, comment: ""), for: .normal)
        }
    }
    
    var flag = true
}

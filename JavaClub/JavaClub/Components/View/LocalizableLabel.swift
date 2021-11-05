//
//  LocalizableLabel.swift
//  JavaClub
//
//  Created by Roy on 2021/10/29.
//

import UIKit

@IBDesignable
class LocalizableLabel: UILabel {

    @IBInspectable var localizedKey: String? {
        didSet {
            guard let key = localizedKey else { return }
            text = NSLocalizedString(key, comment: "")
        }
    }
}

//
//  LocalizableButton.swift
//  JavaClub
//
//  Created by Roy on 2021/11/9.
//

import UIKit

class LocalizableButton: UIButton {
    
    @IBInspectable var localizedKey: String? {
        didSet {
            guard let key = localizedKey else { return }
            setTitle(NSLocalizedString(key, comment: ""), for: .normal)
        }
    }
}

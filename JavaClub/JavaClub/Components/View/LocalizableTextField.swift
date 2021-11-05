//
//  LocalizableTextField.swift
//  JavaClub
//
//  Created by Roy on 2021/11/2.
//

import UIKit

@IBDesignable
class LocalizableTextField: UITextField {
    
    @IBInspectable var localizedPlaceHolder: String? {
        set {
            guard let newValue = newValue else { return }
            placeholder = NSLocalizedString(newValue, comment: "")
        }
        
        get { placeholder }
    }
}

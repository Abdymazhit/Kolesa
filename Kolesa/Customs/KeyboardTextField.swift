//
//  KeyboardTextField.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 22.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

class KeyboardTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

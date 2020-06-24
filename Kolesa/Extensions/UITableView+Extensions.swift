//
//  UITableView+Extensions.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 01.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// динамическая высота для UITableView
extension UITableView {
    override open var intrinsicContentSize: CGSize {
        return contentSize
    }
    
    override open var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
}

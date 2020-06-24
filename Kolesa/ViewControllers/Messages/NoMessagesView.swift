//
//  NoMessagesView.swift
//  Kolesa
//
//  Created by Islam Abdymazhit on 09/05/2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

class NoMessagesView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("NoMessagesView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}

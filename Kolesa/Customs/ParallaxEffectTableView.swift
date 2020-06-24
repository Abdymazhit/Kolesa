//
//  ParallaxEffectTableView.swift
//  Kolesa
//
//  Created by Islam Abdymazhit on 12/05/2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// parallax эффект для headerView UITableView'а
class ParallaxEffectTableView: UITableView {
    
    // MARK: - Private Properties
    private var height: NSLayoutConstraint?
    private var bottom: NSLayoutConstraint?
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // проверить, есть ли headerView
        guard let header = tableHeaderView else { return }
        
        // получить view от headerView
        if let view = header.subviews.first {
            // присвоить height и bottom
            height = view.constraints.filter { $0.identifier == "height" }.first
            bottom = header.constraints.filter { $0.identifier == "bottom" }.first
        }
        
        // при скролле увеличиваем headerView
        let offsetY = -contentOffset.y
        bottom?.constant = offsetY >= 0 ? 0 : offsetY / 2
        height?.constant = max(header.bounds.height, header.bounds.height + offsetY)
        
        header.clipsToBounds = offsetY <= 0
    }
}

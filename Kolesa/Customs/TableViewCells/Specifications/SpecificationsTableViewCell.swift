//
//  SpecificationsTableViewCell.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 10.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UITableViewCell для показа характеристики
class SpecificationsTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var specificationsLabel: UILabel!
    
    // установить характеристики
    func setSpecifications(_ specifications: String) {
        specificationsLabel.text = specifications
    }
}

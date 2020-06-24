//
//  OptionsAndSpecificationsTableViewCell.swift
//  Kolesa
//
//  Created by Islam Abdymazhit on 16/05/2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UITableViewCell для показа опции и характеристики
class OptionsAndSpecificationsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var specificationsLabel: UILabel!
    
    // установить опции
    func setOptions(_ options: String) {
        optionsLabel.text = options
    }
    
    // установить характеристики
    func setSpecifications(_ specifications: String) {
        specificationsLabel.text = specifications
    }
}

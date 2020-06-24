//
//  AdCollectionViewCell.swift
//  Kolesa
//
//  Created by Islam Abdymazhit on 16/05/2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UICollectionViewCell для показа рекомендованного объявления
class AdCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    // установить изображение
    func setImage(url: URL) {
        imageView.setImage(url: url)
    }
    
    // установить название
    func setName(name: String) {
        nameLabel.text = name
    }
    
    // установить цену
    func setPrice(price: Int?) {
        // проверить, существует ли цена
        if let price = price {
            // установить цену с разделением по тысячам (1000000 - 1 000 000)
            priceLabel.text = "\(price.formattedWithSeparator) ₸"
        } else {
            // скрыть цену
            priceLabel.isHidden = true
        }
    }
}

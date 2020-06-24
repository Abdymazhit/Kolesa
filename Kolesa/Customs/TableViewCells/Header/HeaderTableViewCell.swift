//
//  HeaderTableViewCell.swift
//  Kolesa
//
//  Created by Islam Abdymazhit on 10/05/2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UITableViewCell для показа главной информации о объявлений (название, цена, средняя цена, изменение цены объявления)
class HeaderTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!
    @IBOutlet weak var avgPriceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    
    // установить название
    func setName(_ name: String) {
        nameLabel.text = name
    }
    
    // установить цену (цена, средняя цена, изменение цены)
    func setPrice(withUnitPrice unitPrice: Int?, withAvgPrice avgPrice: Int?) {
        // проверка, существует ли цена
        if let unitPrice = unitPrice {
            // установить цену с разделением по тысячам (1000000 - 1 000 000)
            unitPriceLabel.text = "\(unitPrice.formattedWithSeparator) ₸"
            
            // проверка, существует ли средняя цена
            if let avgPrice = avgPrice {
                // создать зачеркнутую цену
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(avgPrice.formattedWithSeparator) ₸")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                
                // установить зачеркнутую цену
                avgPriceLabel.attributedText = attributeString
                
                // получить изменение цены (на сколько % дороже/дешевле в соотношений к средней цене)
                let priceChange = ((unitPrice * 100) / avgPrice) - 100
                // проверка, дороже или дешевле
                if priceChange > 0 {
                    // установить изменение цены (на сколько% дороже)
                    priceChangeLabel.text = "  на \(priceChange)% дороже  "
                    // изменить цвет текста на красную
                    priceChangeLabel.textColor = .systemRed
                    // изменить цвет фона текста на красную
                    priceChangeLabel.backgroundColor = UIColor(red: 252/255, green: 33/255, blue: 37/255, alpha: 0.2)
                } else {
                    // установить изменение цены (на сколько% дешевле)
                    priceChangeLabel.text = "  на \(priceChange * -1)% дешевле  "
                    // изменить цвет текста на зеленую
                    priceChangeLabel.textColor = .systemGreen
                    // изменить цвет фона текста на зеленую
                    priceChangeLabel.backgroundColor = UIColor(red: 52/255, green: 199/255, blue: 89/255, alpha: 0.2)
                }
                
                // установить индикатор раскрытия
                // индикатор показывает существует ли аналитика к этому объявлению
                accessoryType = .disclosureIndicator
            } else {
                // установить среднюю цену и изменение цены невидимым, так как средняя цена не существует
                avgPriceLabel.isHidden = true
                priceChangeLabel.isHidden = true
            }
        } else {
            // установить цену невидимым, так как цена не существует
            unitPriceLabel.isHidden = true
        }
    }
}

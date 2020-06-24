//
//  PromotionTableViewCell.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 13.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UITableViewCell для показа информации о продвижений объявления
class PromotionTableViewCell: UITableViewCell {

    // UITableView, отображающий информацию о продвижений
    @IBOutlet weak var tableView: UITableView!
    
    // массив с данными продвижения
    private var promotion: [PromotionModel]!

    // установить данные продвижения
    func setPromotion(_ promotion: [PromotionModel]) {
        self.promotion = promotion
    }
    
    // установить параметры
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension PromotionTableViewCell: UITableViewDataSource {
    // количество cell = количество способов продвижения
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return promotion.count
    }
    
    // установка информации продвижения для cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let image = promotion[indexPath.row].image, let imageColor = promotion[indexPath.row].imageColor, let text = promotion[indexPath.row].text, let price = promotion[indexPath.row].price {
            cell.imageView?.image = image
            cell.imageView?.tintColor = imageColor
            cell.textLabel?.text = "\(String(text)) \(String(price)) ₸"
            cell.textLabel?.textColor = UIColor(red: 0.0, green: 0.4, blue: 1.0, alpha: 0.7)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PromotionTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

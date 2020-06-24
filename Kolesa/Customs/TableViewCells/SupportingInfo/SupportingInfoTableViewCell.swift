//
//  SupportingInfoTableViewCell.swift
//  Kolesa
//
//  Created by Islam Abdymazhit on 16/05/2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UITableViewCell для показа вспомогательной информаций
class SupportingInfoTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var adIdLabel: UILabel!
    @IBOutlet weak var publicationDateLabel: UILabel!
    @IBOutlet weak var adsViewedLabel: UILabel!
    
    // установить id объявления
    func setId(_ id: Int) {
        adIdLabel.text = "ID объявления: \(String(id))"
    }
    
    // установить дату публикаций
    func setPublicationDate(_ publicationDate: String?) {
        // проверка, есть ли дата публикации
        if let publicationDate = publicationDate {
            // создание форматирования даты
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            // проверка, форматирована ли дата в Date()
            if let date = dateFormatter.date(from: publicationDate) {
                // установить дату с форматированием в русскую
                dateFormatter.dateFormat = "dd MMMM YYYY"
                let stringDate = dateFormatter.string(from: date)
                publicationDateLabel.text = "Дата публикации: \(stringDate)"
            } else {
                // скрыть дату публикации
                publicationDateLabel.isHidden = true
            }
        } else {
            // скрыть дату публикации
            publicationDateLabel.isHidden = true
        }
    }
    
    // установить количество просмотров объявления
    func setAdsViewed(_ adsViewed: Int?) {
        // проверка, есть ли количество просмотров
        if let adsViewed = adsViewed {
            // создать окончание
            // установить количество просмотров
            let last = adsViewed % 10
            if last >= 2 && last <= 4 {
                adsViewedLabel.text = "Объявления просмотрено \(String(adsViewed)) раза"
            } else {
                adsViewedLabel.text = "Объявления просмотрено \(String(adsViewed)) раз"
            }
        } else {
            // скрыть количество просмотров объявления
            adsViewedLabel.isHidden = true
        }
    }
}

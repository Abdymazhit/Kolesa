//
//  ParseAd.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 31.05.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import Kanna

// парсинг страницы объявления
class ParseAd {
    
    // MARK: получить изображения объявления
    func getImages(_ doc: HTMLDocument) -> [URL]? {
        // получить список изображений
        guard let list = doc.css("ul[class='gallery__thumbs-list js__gallery-thumbs']").first else { return nil }
        
        // создать массив с url изображениями
        var images = [URL]()
        
        // перебор изображения
        for image in list.css("button") {
            // получить url и добавить в массив
            guard let imageURL = image["data-href"] else { return nil }
            guard let url = URL(string: imageURL) else { return nil }
            images.append(url)
        }
        
        // проверить, есть ли изображения
        if images.isEmpty {
            guard let mainGallery = doc.css("button[class='gallery__main js__gallery-main']").first else { return nil }
            guard let imageURL = mainGallery["data-href"] else { return nil }
            guard let url = URL(string: imageURL) else { return nil }
            images.append(url)
            
            return images
        } else {
            return images
        }
    }
    
    // MARK: получить информацию о объявлений
    func getInfoData(_ doc: HTMLDocument) -> [DictionaryModel]? {
        // получить список с информацией
        guard let list = doc.css("div[class='offer__parameters']").first else { return nil }
        
        // создать массив с информацией
        var infoData = [DictionaryModel]()
        
        // перебор информаций
        for info in list.css("dl") {
            // получить информацию
            guard let key = info.css("dt[class='value-title']").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
            guard let value = info.css("dd[class='value']").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
            
            // добавить информацию в массив
            infoData.append(DictionaryModel(key: key, value: value))
        }
        
        // проверить, есть ли информация
        guard infoData.count > 0 else { return nil }
        
        // вернуть информацию
        return infoData
    }
    
    // MARK: получить опции и характеристики объявления
    func getOptionsAndSpecifications(_ doc: HTMLDocument) -> (String?, String?) {
        // инициализация опции и характеристики
        var options = ""
        var specifications = ""
        
        // перебор данных
        for data in doc.css("div[class='text']") {
            // проверить, является ли опцией (проверить, есть ли 'span', так как опции находятся внутри 'span', а характеристики нет)
            guard let html = data.toHTML else { return (nil, nil) }
            if html.contains("span") {
                // перебор опции
                for span in data.css("span") {
                    // проверить, имеет ли текст
                    if let text = span.text {
                        // добавить опции
                        options += String(text).trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                }
            } else {
                // проверить, имеет ли текст
                if let text = data.text {
                    // добавить в характеристики
                    specifications += String(text).trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
        
        // проверить, имеет ли опции
        if options.isEmpty {
            // проверить, имеет ли характеристики
            if specifications.isEmpty {
                // опции и характеристики не существуют
                return (nil, nil)
            } else {
                // опции не существует
                return (nil, specifications)
            }
        } else {
            // проверить, имеет ли характеристики
            if specifications.isEmpty {
                // характеристики не существует
                return (options, nil)
            } else {
                // опции и характеристики существуют
                return (options, specifications)
            }
        }
    }
    
    // MARK: получить массив с продвижением объявления
    func getPromotion(_ doc: HTMLDocument) -> [PromotionModel]? {
        // создать массив с продвижением
        var promotions = [PromotionModel]()
        
        // перебор продвижения
        for promotion in  doc.css("li[class='payments__button kl-tooltip-cover js__payment-button']") {
            // получить тип и цену
            guard let service = promotion["data-service"] else { return nil }
            guard let dataPrice = promotion["data-price"] else { return nil }
            guard let price = Int(dataPrice) else { return nil}
            
            // создать продвижение
            var model = PromotionModel(image: nil, imageColor: nil, text: nil, price: nil)
            
            // проверить, каким типом является продвижение
            // установить данные в связи с типом
            if service.contains("vip") {
                model.image = UIImage(systemName: "bolt.fill")
                model.imageColor = .red
                model.text = "Стать VIP за"
                model.price = price
            } else if service.contains("re") {
                model.image = UIImage(systemName: "arrow.counterclockwise.circle.fill")
                model.imageColor = .link
                model.text = "Продлить за"
                model.price = price
            } else if service.contains("up") {
                model.image = UIImage(systemName: "triangle.fill")
                model.imageColor = .orange
                model.text = "Отправить в «ТОП» за"
                model.price = price
            } else if service.contains("hot") {
                model.image = UIImage(systemName: "flame.fill")
                model.imageColor = .red
                model.text = "В горячие за"
                model.price = price
            }
            
            // добавить продвижение в массив
            promotions.append(model)
        }
        
        // вернуть продвижения
        return promotions
    }
    
    // MARK: получить массив рекомендуемых запчастей для объявления
    func getSpares(_ doc: HTMLDocument) -> [RecommendedAdModel]? {
        // получить список запчастей
        guard let list = doc.css("div[class='related-list']").first else { return nil }
        
        // создать массив рекомендованных объявлений
        var spares = [RecommendedAdModel]()
        
        // перебор каждого объявления
        for item in list.css("a") {
            // получить id, название и изображение объявления
            guard let href = item["href"] else { return nil }
            guard let id = Int(href.digits) else { return nil }
            guard let name = item.css("div[class='related-item__title']").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
            guard let image = item.css("picture").first?.at_css("img")?["src"] else { return nil }
            guard let imageURL = URL(string: image) else { return nil }
            
            // получить цену, если есть
            let price = item.css("div[class='related-item__price']").first?.text?.digits
            // добавить в массив объявление
            if let price = price {
                spares.append(RecommendedAdModel(id: id, imageURL: imageURL, name: name, price: Int(price)))
            } else {
                spares.append(RecommendedAdModel(id: id, imageURL: imageURL, name: name, price: nil))
            }
        }
        
        // проверить, есть ли запчасти
        guard spares.count > 0 else { return nil }
        
        // вернуть массив запчастей
        return spares
    }
    
    // MARK: получить массив похожих объявлений для объявления
    func getSimilar(_ doc: HTMLDocument) -> [RecommendedAdModel]? {
        // получить список похожих объявлений
        guard let list = doc.css("div[class='related-list js-type-related']").first else { return nil }
        
        // создать массив похожих объявлений
        var similar = [RecommendedAdModel]()
        
        // перебор каждого объявления
        for item in list.css("a") {
            // получить id, название и изображение объявления
            guard let href = item["href"] else { return nil }
            guard let id = Int(href.digits) else { return nil }
            guard let name = item.css("div[class='related-item__title']").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
            guard let image = item.css("picture").first?.at_css("img")?["src"] else { return nil }
            guard let imageURL = URL(string: image) else { return nil }
            
            // получить цену, если есть
            let price = item.css("div[class='related-item__price']").first?.text?.digits
            // добавить в массив объявление
            if let price = price {
                similar.append(RecommendedAdModel(id: id, imageURL: imageURL, name: name, price: Int(price)))
            } else {
                similar.append(RecommendedAdModel(id: id, imageURL: imageURL, name: name, price: nil))
            }
        }
        
        // проверить, есть ли похожие объявления
        guard similar.count > 0 else { return nil }
        
        // вернуть массив с похожими объявлениями
        return similar
    }
    
    // MARK: получить количество просмотров объявления
    func getAdsViewed(_ doc: HTMLDocument) -> Int? {
        // преобразовываем в JSON
        guard let jsonData = doc.text?.data(using: .utf8) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else { return nil }
        // получаем данные о просмотрах
        guard let data = json["data"] as? [String: Any] else { return nil }
        guard let dictionary = data.first?.value as? [String: Any] else { return nil }
        
        //получаем количество просмотров объявления
        let adsViewed = dictionary["nb_views"]
        return adsViewed as? Int
    }
}

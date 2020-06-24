//
//  AdViewModel.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 19.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import Foundation

class AdViewModel {
    
    // MARK: - Private Properties
    private var ad: Ad!
    
    // MARK: - Properties
    var id: Int
    
    var name: String {
        return ad.product.name
    }
    
    var unitPrice: Int? {
        return ad.product.unitPrice
    }
    
    var avgPrice: Int? {
        return ad.product.attributes.avgPrice
    }
    
    var isCreditAvailable: Bool {
        return ad.product.isCreditAvailable
    }
    
    var photoCount: Int {
        return ad.product.photoCount
    }
    
    var commentsCount: Int {
        return ad.product.commentsCount
    }
    
    var publicationDate: String {
        return ad.product.publicationDate
    }
    
    var images: [URL] {
        return ad.product.images
    }
    
    var infoData: [DictionaryModel] {
        return ad.product.infoData
    }
    
    var options: String? {
        return ad.product.options
    }
    
    var specifications: String? {
        return ad.product.specifications
    }
    
    var promotion: [PromotionModel]? {
        return ad.product.promotion
    }
    
    var spares: [RecommendedAdModel]? {
        return ad.product.spares
    }
    
    var similar: [RecommendedAdModel]? {
        return ad.product.similar
    }
    
    var adsViewed: Int? {
        return ad.product.adsViewed
    }
    
    // MARK: - Init
    init(id: Int) {
        self.id = id
    }
    
    // MARK: - получить данные
    func fetchData(completion: @escaping (Result<Ad, ParseError>) -> Void) {
        // инициализация класса парсинга страницы объявления
        let parse = ParseAd()
        
        // получить HTML документ по url
        Parse.shared.getHTMLDocument("https://kolesa.kz/a/show/\(id)", completion: { result in
            // проверить, успешно ли прошёл запрос
            switch result {
            case .success(let doc):
                // перебор скриптов
                for script in doc.css("script") {
                    // проверить, есть ли текст у скрипта
                    guard let text = script.text else { return }
                    // проверить, имеет ли текст 'window.digitalData'
                    // т.к. скрипт с 'window.digitalData' имеет в себе основные данные о объявлений
                    if text.contains("window.digitalData") {
                        // разбор текст для json
                        let data = text.components(separatedBy: " if")[0].components(separatedBy: "window.digitalData = ")[1].replacingOccurrences(of: ";", with: "")
                        // получить json данные
                        let jsonData = Data(data.utf8)
                        
                        // установить данные
                        var ad = try? JSONDecoder().decode(Ad.self, from: jsonData)
                        // пропарсить остальные данные
                        guard let images = parse.getImages(doc) else { return completion(.failure(.noImagesData)) }
                        guard let infoData = parse.getInfoData(doc) else { return completion(.failure(.noInfoData)) }
                        let (options, specifications) = parse.getOptionsAndSpecifications(doc)
                        let promotion = parse.getPromotion(doc)
                        let spares = parse.getSpares(doc)
                        let similar = parse.getSimilar(doc)
                        
                        // установить остальные данные
                        ad?.product.images = images
                        ad?.product.infoData = infoData
                        ad?.product.options = options
                        ad?.product.specifications = specifications
                        ad?.product.promotion = promotion
                        ad?.product.spares = spares
                        ad?.product.similar = similar
                        self.ad = ad
                        
                        // получить HTML документ по url
                        // получить информацию о просмотрах объявлений
                        Parse.shared.getHTMLDocument("https://kolesa.kz/ms/views/kolesa/live/\(self.id)/", completion: { result in
                            // проверить, успешно ли прошёл запрос
                            switch result {
                            case .success(let doc):
                                // получить просмотры и установить
                                let adsViewed = parse.getAdsViewed(doc)
                                self.ad?.product.adsViewed = adsViewed

                                completion(.success(self.ad))
                            case .failure(let error):
                                // случилась ошибка, при попытке получить просмотры объявления
                                // вернуть данные о объявлений
                                // т.к. количество просмотров объявления не мешают просмотру объявления
                                print(error)
                                completion(.success(self.ad))
                            }
                        })
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

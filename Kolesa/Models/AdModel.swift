//
//  AdModel.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 01.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import Foundation

// MARK: - Ad
struct Ad: Codable {
    var product: Product
}

// MARK: - Product
struct Product: Codable {
    let id: Int
    let seller: Seller
    let name: String
    let unitPrice: Int?
    let attributes: Attributes
    let isCreditAvailable: Bool
    let commentsCount, photoCount: Int
    let appliedPaidServices: [String]?
    let publicationDate: String
    
    var images: [URL]!
    var infoData: [DictionaryModel]!
    var options: String?
    var specifications: String?
    var promotion: [PromotionModel]?
    var spares: [RecommendedAdModel]?
    var similar: [RecommendedAdModel]?
    var adsViewed: Int?

    enum CodingKeys: String, CodingKey {
        case name, id, publicationDate, isCreditAvailable, seller, commentsCount, photoCount, attributes, unitPrice, appliedPaidServices
    }
}

// MARK: - Attributes
struct Attributes: Codable {
    let model, brand: String
    let avgPrice: Int?
}

// MARK: - Seller
struct Seller: Codable {
    let id, userID: Int

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
    }
}

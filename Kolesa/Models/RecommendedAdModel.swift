//
//  RecommendedAdModel.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 02.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

struct RecommendedAdModel {

    let id: Int
    let imageURL: URL
    let name: String
    let price: Int?
    
    init(id: Int, imageURL: URL, name: String, price: Int?) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.price = price
    }
}

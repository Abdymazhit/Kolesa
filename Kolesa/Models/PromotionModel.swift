//
//  PromotionModel.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 13.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

struct PromotionModel {

    var image: UIImage?
    var imageColor: UIColor?
    var text: String?
    var price: Int?

    init(image: UIImage?, imageColor: UIColor?, text: String?, price: Int?) {
        self.image = image
        self.imageColor = imageColor
        self.text = text
        self.price = price
    }
}

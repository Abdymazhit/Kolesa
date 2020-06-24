//
//  ImagesView.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 28.05.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UIView для показа изображений объявления
class ImagesView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imagesCountLabel: UILabel!
    
    // создать UIActivityIndicatorView с стилем 'medium'
    private let indicator = UIActivityIndicatorView(style: .medium)
    
    // установить изображение
    func setImage(image: UIImage?) {
        // проверить, есть ли изображение
        if let image = image {
            // установить изображение
            imageView.image = image
            // удалить индикатор
            imageView.removeIndicator(indicator: indicator)
        } else {
            // добавить индикатор
            imageView.addIndicator(indicator: indicator, color: .black)
        }
    }
    
    // установить количество изображений
    func setImagesCount(count: Int) {
        imagesCountLabel.text = "  \(count) фото.  "
    }
}

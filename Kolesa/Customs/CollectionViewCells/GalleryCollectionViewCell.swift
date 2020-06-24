//
//  GalleryCollectionViewCell.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 08.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UICollectionViewCell для показа галереи
class GalleryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    // создать UIActivityIndicatorView с стилем 'medium'
    private let indicator = UIActivityIndicatorView(style: .medium)
    
    // установить изображение
    func setImage(image: UIImage?) {
        if let image = image {
            imageView.image = image
            imageView.removeIndicator(indicator: indicator)
        } else {
            imageView.addIndicator(indicator: indicator, color: .black)
        }
    }
    
    // установить image = nil
    // т.к. при прокрутке данные меняются
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
    }
}

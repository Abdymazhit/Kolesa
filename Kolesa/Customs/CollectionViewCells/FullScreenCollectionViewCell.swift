//
//  FullScreenCollectionViewCell.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 09.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UICollectionViewCell для показа изображения в полноэкранном режиме
class FullScreenCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
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

    // установить параметры
    override func awakeFromNib() {
        super.awakeFromNib()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
}

// MARK: - UIScrollViewDelegate
extension FullScreenCollectionViewCell: UIScrollViewDelegate {
    // UIView при масштабировании
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

//
//  UIImageView+Extensions.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 07.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

extension UIImageView {
    
    // загрузить изображение из url
    func setImage(url: URL) {
        // до загрузки изображения будет работать по середине индикатор
        let indicator = UIActivityIndicatorView.init(style: .large)
        addIndicator(indicator: indicator, color: .black)
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        // удалить индикатор
                        self?.removeIndicator(indicator: indicator)
                    }
                }
            }
        }
    }
    
    // добавить индикатор по середине UIImageView
    func addIndicator(indicator: UIActivityIndicatorView, color: UIColor) {
        indicator.color = color
        indicator.center = center
        indicator.startAnimating()
        addSubview(indicator)
    }
    
    // удалить индикатор
    func removeIndicator(indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
    }
}

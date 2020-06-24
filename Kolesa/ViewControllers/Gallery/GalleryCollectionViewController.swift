//
//  GalleryCollectionViewController.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 08.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UICollectionViewController для показа галерий изображений
class GalleryCollectionViewController: UICollectionViewController {

    // MARK: - Private Properties
    private var images: [Int: AnyObject?]!
    private var fullScreenViewController: FullScreenCollectionViewController!
    
    // установить изображения
    func setImages(images: [Int: AnyObject?]) {
        self.images = images
        if let fullScreenViewController = fullScreenViewController {
            fullScreenViewController.setImages(images: images)
        }
        collectionView.reloadData()
    }
    
    // операции перед появлением
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.navigationController?.navigationBar.barStyle = .default
        }
        
        title = "Галерея фотографий"
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    // установить размер для cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width  = (view.frame.width - 10) / 2
            return CGSize(width: width, height: width)
      }
}

// MARK: - UICollectionViewDataSource
extension GalleryCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    // установить изображение для cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GalleryCollectionViewCell else { return UICollectionViewCell() }
        if let images = images {
            if let image = images[indexPath.row] {
                if let image = image {
                    cell.setImage(image: image as? UIImage)
                } else {
                    cell.setImage(image: nil)
                }
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension GalleryCollectionViewController {
    // переход в UIViewController, который показывает изображения в полноэкранном режиме
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if fullScreenViewController == nil {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Gallery", bundle: nil)
            fullScreenViewController = storyBoard.instantiateViewController(withIdentifier: "FullScreenCollectionViewController") as? FullScreenCollectionViewController
        }
        fullScreenViewController.setCurrentImageIndex(currentImageIndex: indexPath.row)
        fullScreenViewController.setImages(images: images)
        navigationController?.pushViewController(fullScreenViewController, animated: true)
    }
}

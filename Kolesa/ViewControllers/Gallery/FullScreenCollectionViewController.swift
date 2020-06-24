//
//  FullScreenCollectionViewController.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 09.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UICollectionViewController для показа изображений в полноэкранном режиме
class FullScreenCollectionViewController: UICollectionViewController {
    
    // MARK: - Private Properties
    private var images: [Int: AnyObject?]!
    private var currentImageIndex: Int!
    
    // установить изображения
    func setImages(images: [Int: AnyObject?]) {
        self.images = images
        collectionView.reloadData()
    }
    
    // установить выбранный индекс изображения
    func setCurrentImageIndex(currentImageIndex: Int) {
        self.currentImageIndex = currentImageIndex
    }
    
    // операции перед появлением
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // перелистать до выбранного индекса изображения
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath(row: self.currentImageIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    // добавить обработчик нажатия на view
    override func viewDidLoad() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(someAction))
        view.addGestureRecognizer(gesture)
    }
    
    // показать/скрыть navigationBar при нажатии
    @objc func someAction(_ sender: UITapGestureRecognizer) {
        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == false, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FullScreenCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

// MARK: - UICollectionViewDataSource
extension FullScreenCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    // установить изображение для cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FullScreenCollectionViewCell else { return UICollectionViewCell() }
        if let images = self.images {
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
    
    // установить новый заговолок (1 из 20 (фото))
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
            if let indexPath = indexPath {
                title = "\(String(indexPath.row + 1)) из \(images.count)"
            }
        }
    }
    
    // установить новый заговолок (1 из 20 (фото))
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        title = "\(String(indexPath.row + 1)) из \(images.count)"
    }
}

//
//  SimilarTableViewCell.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 28.05.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UITableViewCell для отображения похожих объявлений
class SimilarTableViewCell: UITableViewCell {
     
     // UICollectionView, отображающий похожие объявления
     @IBOutlet var collectionView: UICollectionView!
     
     // UIViewController, через который будет реализован pushViewController
     private var viewController: UIViewController!
     // массив с похожими объявлениями
     private var similar: [RecommendedAdModel]!

     // установить данные
     func setData(viewController: UIViewController, similar: [RecommendedAdModel]) {
         self.viewController = viewController
         self.similar = similar
     }
     
     // установить параметры
     override func awakeFromNib() {
          super.awakeFromNib()
          collectionView.register(UINib(nibName: "AdCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
          collectionView.dataSource = self
          collectionView.delegate = self
     }
}

// MARK: - UICollectionViewDataSource
extension SimilarTableViewCell: UICollectionViewDataSource {
     // количество cell = количество похожих объявлений
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return similar.count
     }
     
     // установить информации о похожем объявлений для cell
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? AdCollectionViewCell else { return UICollectionViewCell() }
          cell.setImage(url: similar[indexPath.row].imageURL)
          cell.setPrice(price: similar[indexPath.row].price)
          cell.setName(name: similar[indexPath.row].name)
          return cell
     }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SimilarTableViewCell: UICollectionViewDelegateFlowLayout {
     // установить размер для cell
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let height = (collectionView.bounds.size.height - 10) / 2
          return CGSize(width: height / 1.2, height: height)
     }
}

// MARK: - UICollectionViewDelegate
extension SimilarTableViewCell: UICollectionViewDelegate {
     // переход по объявлению при нажатии
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          let storyBoard: UIStoryboard = UIStoryboard(name: "Ads", bundle: nil)
          guard let adViewController = storyBoard.instantiateViewController(withIdentifier: "AdViewController") as? AdViewController else { return }
          adViewController.id = similar[indexPath.row].id
          viewController.navigationController?.pushViewController(adViewController, animated: true)
     }
}

//
//  SparesTableViewCell.swift
//  Kolesa
//
//  Created by Islam Abdymazhit on 12/05/2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UITableViewCell для показа рекомендованных запчастей
class SparesTableViewCell: UITableViewCell {
    
    // UICollectionView, отображающий запчасти
    @IBOutlet var collectionView: UICollectionView!
    
    // UIViewController, через который будет реализован pushViewController
    private var viewController: UIViewController!
    // массив с запчастями
    private var spares: [RecommendedAdModel]!
    
    // установить данные
    func setData(viewController: UIViewController, spares: [RecommendedAdModel]) {
        self.viewController = viewController
        self.spares = spares
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
extension SparesTableViewCell: UICollectionViewDataSource {
    // количество cell = количество запчастей
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spares.count
    }
    
    // установить информации о запчасти для cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? AdCollectionViewCell else { return UICollectionViewCell() }
        cell.setImage(url: spares[indexPath.row].imageURL)
        cell.setName(name: spares[indexPath.row].name)
        cell.setPrice(price: spares[indexPath.row].price)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SparesTableViewCell: UICollectionViewDelegateFlowLayout {
    // установить размер для cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.size.height
        return CGSize(width: height / 1.2, height: height)
    }
}

// MARK: - UICollectionViewDelegate
extension SparesTableViewCell: UICollectionViewDelegate {
    // переход по объявлению при нажатии
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Ads", bundle: nil)
        guard let adViewController = storyBoard.instantiateViewController(withIdentifier: "AdViewController") as? AdViewController else { return }
        adViewController.id = spares[indexPath.row].id
        viewController.navigationController?.pushViewController(adViewController, animated: true)
    }
}

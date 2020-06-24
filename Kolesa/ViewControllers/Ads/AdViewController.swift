//
//  AdViewController.swift
//  Kolesa
//
//  Created by Islam Abdymazhit on 10/05/2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UITableViewController для показа страницы объявления
class AdViewController: UITableViewController {
    
    // 'id' объявления
    var id: Int!
    
    // MARK: - Private Properties
    private var viewModel: AdViewModel!
    private var cells = [UITableViewCell]()
    private var images = [Int: AnyObject?]()
    private var footerView = UIView()
    private var galleryViewController: GalleryCollectionViewController!
    
    // операции перед появлением
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // проверить, существует ли 'id' объявления
        if let id = id {
            navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationController?.navigationBar.shadowImage = UIImage()
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left.circle.fill"), style: .plain, target: self, action: #selector(popViewController))
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.barStyle = .black
            
            // проверить, существует ли viewModel
            if viewModel == nil {
                // инициализировать и получить данные из viewModel
                viewModel = AdViewModel(id: id)
                viewModel.fetchData(completion: { (result) in
                    // проверить, успешно ли прошёл запрос
                    switch result {
                    case .success:
                        // настроить все данные для показа
                        self.configure()
                    case .failure:
                        // переход на предыдущий UIViewController
                        self.popViewControllerWithError()
                    }
                })
            } else {
                // переход в самый верх страницы
                tableView.setContentOffset(.zero, animated: true)
            }
        } else {
            // переход на предыдущий UIViewController
            popViewControllerWithError()
        }
    }
    
    // переход на предыдущий UIViewController
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    
    // переход на предыдущий UIViewController с ошибкой AlertView
    @objc func popViewControllerWithError() {
        let alert = UIAlertController(title: "Ошибка при попытке получить доступ к объявлению", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Окей", style: .default) { (action: UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true, completion: nil)
    }
    
    // установить обработчики для клавиатуры (открытие, закрытие)
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    // настроить все данные для показа
    private func configure() {
        addImagesView()
        addHeaderCell()
        addLoansCell()
        addInformationCell()
        addOptionsAndSpecificationsCell()
        addCommentsCell()
        addPromotionCell()
        addSupportingInfoCell()
        addSparesCell()
        addSimilarCell()
        if let footerView = Bundle.main.loadNibNamed("FooterView", owner: self, options: nil)?.first as? UIView {
            self.footerView = footerView
        }
        tableView.reloadData()
    }
    
    // скрыть FooterView при открытии клавиатуры
    @objc func keyboardWillShow(notification: NSNotification) {
        footerView.isHidden = true
    }
    
    // показать FooterView при закрытии клавиатуры
    @objc func keyboardWillHide(notification: NSNotification) {
        footerView.isHidden = false
    }
    
    // добавить ImagesView (включает в себя все фотография объявления)
    private func addImagesView() {
        // инициализировать ImagesView
        guard let headerView = Bundle.main.loadNibNamed("ImagesView", owner: self, options: nil)?.first as? ImagesView else { return }
        // установить изображение 'nil', т.к. нужно сначала загрузить изображение
        // а, при 'nil' будет работать индикатор загрузки изображения
        headerView.setImage(image: nil)
        // установить количество изображения
        headerView.setImagesCount(count: viewModel.photoCount)
        // добавить обработку нажатия
        headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectHeaderView)))
        // установить ImageView как tableHeaderView
        tableView.tableHeaderView = headerView
        
        // добавить для всех изображений в массиве 'nil'
        // т.к. при 'nil' будет работать индикатор загрузки изображения
        for i in 0..<viewModel.photoCount {
            images[i] = nil as AnyObject?
        }
        
        // загрузить изображения по url
        DispatchQueue.global().async { [weak self] in
            // получить индекс и url изображения из массива
            for (index, url) in self!.viewModel.images.enumerated() {
                // получить данные о изображений и преобразовать в UIImage
                guard let data = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: data) else { return }
                
                // установить фотография
                DispatchQueue.main.async {
                    // проверить, является ли индекс '0'
                    // индекс '0' = первое (главное) изображение, которое отображается
                    // необходимо присвоить сразу
                    // т.к. оно является самым главным и находить отдельно в странице объявления
                    if index == 0 {
                        headerView.setImage(image: image)
                    }
                    
                    // установить изображения по индексу
                    self?.images[index] = image
                    
                    // проверить, есть ли галерея фотографий объявления
                    if let galleryViewController = self?.galleryViewController {
                        // установить изображения в галерее фотографий
                        galleryViewController.setImages(images: self!.images)
                    }
                }
            }
        }
    }
    
    // добавить cell с главной информацией (название, цена, средняя цена, изменение цены объявления)
    private func addHeaderCell() {
        guard let cell = Bundle.main.loadNibNamed("HeaderTableViewCell", owner: self, options: nil)?.first as? HeaderTableViewCell else { return }
        cell.setName(viewModel.name)
        cell.setPrice(withUnitPrice: viewModel.unitPrice, withAvgPrice: viewModel.avgPrice)
        cells.append(cell)
    }
    
    // добавить cell для кредитирования
    private func addLoansCell() {
        // проверить, доступно ли кредитирование для объявления
        guard viewModel.isCreditAvailable else { return }
        guard let unitPrice = viewModel.unitPrice else { return }
        guard let cell = Bundle.main.loadNibNamed("LoansTableViewCell", owner: self, options: nil)?.first as? LoansTableViewCell else { return }
        cell.setData(viewController: self, id: viewModel.id, carCost: unitPrice)
        cells.append(cell)
    }
    
    // добавить cell с информацией о объявлений
    private func addInformationCell() {
        guard let cell = Bundle.main.loadNibNamed("InformationTableViewCell", owner: self, options: nil)?.first as? InformationTableViewCell else { return }
        cell.setInfoData(viewModel.infoData)
        cells.append(cell)
    }
    
    // добавить cell для опции и характеристики
    private func addOptionsAndSpecificationsCell() {
        // проверить, существует ли характеристики
        guard let specifications = viewModel.specifications else { return }
        // проверить, существуют ли опции
        // если не существуют, сделать отдельное cell для характеристики
        if let options = viewModel.options {
            guard let cell = Bundle.main.loadNibNamed("OptionsAndSpecificationsTableViewCell", owner: self, options: nil)?.first as? OptionsAndSpecificationsTableViewCell else { return }
            cell.setOptions(options)
            cell.setSpecifications(specifications)
            cells.append(cell)
        } else {
            guard let cell = Bundle.main.loadNibNamed("SpecificationsTableViewCell", owner: self, options: nil)?.first as? SpecificationsTableViewCell else { return }
            cell.setSpecifications(specifications)
            cells.append(cell)
        }
    }
    
    // добавить cell для комментариев
    private func addCommentsCell() {
        guard let cell = Bundle.main.loadNibNamed("CommentsCountTableViewCell", owner: self, options: nil)?.first as? CommentsCountTableViewCell else { return }
        cell.setViewController(self)
        cell.setCommentsCount(viewModel.commentsCount)
        cells.append(cell)
    }
    
    // добавить cell для продвижения
    private func addPromotionCell() {
        // проверить, существует ли продвижение для объявления
        guard let promotion = viewModel.promotion else { return }
        guard let cell = Bundle.main.loadNibNamed("PromotionTableViewCell", owner: self, options: nil)?.first as? PromotionTableViewCell else { return }
        cell.setPromotion(promotion)
        cells.append(cell)
    }
    
    // добавить cell для показа дополнительной информации
    private func addSupportingInfoCell() {
        guard let cell = Bundle.main.loadNibNamed("SupportingInfoTableViewCell", owner: self, options: nil)?.first as? SupportingInfoTableViewCell else { return }
        cell.setId(viewModel.id)
        cell.setPublicationDate(viewModel.publicationDate)
        cell.setAdsViewed(viewModel.adsViewed)
        cells.append(cell)
    }
    
    // добавить cell для показа рекомендуемых запчастей
    private func addSparesCell() {
        // проверить, существуют ли запчасти
        guard let spares = viewModel.spares else { return }
        guard let cell = Bundle.main.loadNibNamed("SparesTableViewCell", owner: self, options: nil)?.first as? SparesTableViewCell else { return }
        cell.setData(viewController: self, spares: spares)
        cells.append(cell)
    }
    
    // добавить cell для показа похожих объявлений
    private func addSimilarCell() {
        // проверить, существует ли похожие объявления
        guard let similar = viewModel.similar else { return }
        guard let cell = Bundle.main.loadNibNamed("SimilarTableViewCell", owner: self, options: nil)?.first as? SimilarTableViewCell else { return }
        cell.setData(viewController: self, similar: similar)
        cells.append(cell)
    }
}

// MARK: - UITableViewDataSource
extension AdViewController {    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
}

// MARK: - UIScrollViewDelegate
extension AdViewController {
    // прокрутка страницы
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // получить высоту tableHeaderView
        if let headerViewHeight = tableView.tableHeaderView?.bounds.height {
            // получить высоту statusBar'а
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            // получить высоту navigationBar'а
            let navigationBarHeight = statusBarHeight + (navigationController?.navigationBar.frame.height ?? 0.0)
            
            // проверить, прокрутил ли пользователь tableHeaderView
            if scrollView.contentOffset.y >= headerViewHeight - navigationBarHeight {
                // добавить фон для navigationBar
                // изменить стиль navigationBar'а
                // установить заговолок
                navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
                navigationController?.navigationBar.shadowImage = nil
                navigationController?.navigationBar.tintColor = .black
                navigationController?.navigationBar.barStyle = .default                
                title = viewModel.name
            } else {
                // убрать фон от navigationBar
                // изменить стиль navigationBar'а
                // убрать заговолок
                navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationController?.navigationBar.shadowImage = UIImage()
                navigationController?.navigationBar.tintColor = .white
                navigationController?.navigationBar.barStyle = .black
                title = nil
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension AdViewController {
    // нажатие на изображение объявления
    @objc func didSelectHeaderView() {
        // создать галарею фотографий объявления
        if galleryViewController == nil {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Gallery", bundle: nil)
            galleryViewController = storyBoard.instantiateViewController(withIdentifier: "GalleryCollectionViewController") as? GalleryCollectionViewController
        }
        // установить изображения
        galleryViewController.setImages(images: images)
        // переход в галерею объявлений
        navigationController?.pushViewController(galleryViewController, animated: true)
    }
    
    // FooterView (связ с автором) будет всегда снизу экрана
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
}

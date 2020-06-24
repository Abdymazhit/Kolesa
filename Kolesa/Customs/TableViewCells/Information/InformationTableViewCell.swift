//
//  InformationTableViewCell.swift
//  Kolesa
//
//  Created by Islam Abdymazhit on 10/05/2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UITableViewCell для показа информации о объявлений
class InformationTableViewCell: UITableViewCell {

    // UITableView, отображающий информацию
    @IBOutlet var tableView: UITableView!

    // массив с информационными данными
    private var infoData: [DictionaryModel]!

    // установить информационные данные
    func setInfoData(_ infoData: [DictionaryModel]) {
        self.infoData = infoData
    }

    // установить параметры
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension InformationTableViewCell: UITableViewDataSource {
    // количество cell = количество информации
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoData.count
    }
    
    // установка информации для cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = infoData[indexPath.row].key
        cell.detailTextLabel?.text = infoData[indexPath.row].value
        return cell
    }
}

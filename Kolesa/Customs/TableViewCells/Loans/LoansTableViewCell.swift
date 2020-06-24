//
//  LoansTableViewCell.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 28.05.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit
import Alamofire

class LoansTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var monthlyPaymentLabel: UILabel!
    @IBOutlet weak var carCostTextField: UITextField!
    @IBOutlet weak var carCostError: UILabel!
    @IBOutlet weak var initialFeeTextField: UITextField!
    @IBOutlet weak var initialFeeError: UILabel!
    @IBOutlet weak var monthPeriodSegmentedControl: UISegmentedControl!
    
    // MARK: - Private Properties
    private var viewController: AdViewController!
    private var id: Int!
    private var monthPay: [String: Any]!
    
    // установить параметры
    override func awakeFromNib() {
        super.awakeFromNib()
        carCostTextField.delegate = self
        initialFeeTextField.delegate = self
        
        // изменить цвет текста для выбранного сегмента на белый
        monthPeriodSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        // изменить цвет текста для не выбранных сегментов на черный
        monthPeriodSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
    }
    
    // установить данные
    func setData(viewController: AdViewController, id: Int, carCost: Int) {
        self.viewController = viewController
        self.id = id
        // установить цену с разделением по тысячам (1000000 - 1 000 000)
        carCostTextField.text = carCost.formattedWithSeparator
        
        // получить минимальный стоимость первоначального взноса
        // создать параметры для запроса
        let parameters: [String: Any] = ["advertId": id as Any, "creditPeriod": 12, "segment": 1, "carCost": carCost, "deposit": 0]
        // запрос данных от API
        AF.request("https://kolesa.kz/credit/ajax-calculation/", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON { response in
            // проверка, успешно ли прошёл запрос
            switch response.result {
            case .success(let success):
                // проверка, являются ли данные типом [String: Any]
                guard let data = success as? [String: Any] else { return }
                // проверка, существует ли ошибка валидаций с типом [String: Any]
                guard let errorValidation = data["errorValidation"] as? [String: Any] else { return }
                // проверка, существует ли ошибка первоначального взноса с типом String
                guard let initPay = errorValidation["initPay"] as? String else { return }
                // получить цифры от ошибки первоначального взноса
                // в ошибке указывается минимальный первоначальный взнос
                guard let digits = Int(initPay.digits) else { return }
                // установить минимальную цену первоначального взноса
                self.initialFeeTextField.text = digits.formattedWithSeparator
                // получить данные платёжа в месяц по стоимостью автомобиля и первоначального взноса
                self.getLoan(carCost: carCost, initialFee: digits)
            case .failure:
                print("error")
            }
        }
    }
    
    // установить платёж в месяц
    func setMonthPay(_ monthPay: [String: Any]) {
        self.monthPay = monthPay
        
        // получить выбранный индекс(год) кредитирования
        let selectedIndex = monthPeriodSegmentedControl.selectedSegmentIndex
        
        // удалить все сегменты
        monthPeriodSegmentedControl.removeAllSegments()
        
        // добавить сегменты с текстом кредитирования по годам
        for i in 0..<monthPay.count {
            monthPeriodSegmentedControl.insertSegment(withTitle: "\((i + 1) * 12) мес.", at: i, animated: false)
        }
        
        // получить и установить платёж в месяц выбранного года
        if let price = monthPay["\((selectedIndex + 1) * 12)"] as? Int {
            monthlyPaymentLabel.text = "  \(price.formattedWithSeparator) ₸  "
        }
        
        // установить выбранный индекс
        monthPeriodSegmentedControl.selectedSegmentIndex = selectedIndex
    }
    
    // получить данные платёжа в месяц по стоимостью автомобиля и первоначального взноса
    func getLoan(carCost: Int, initialFee: Int) {
        // создание параметров для запроса
        let parameters: [String: Any] = ["advertId": id as Any, "creditPeriod": 12, "segment": 1, "carCost": carCost, "deposit": initialFee]
        
        // запрос данных от API
        AF.request("https://kolesa.kz/credit/ajax-calculation/", method: .post, parameters: parameters, encoding: URLEncoding.httpBody).responseJSON { response in
            // проверка, успешно ли прошёл запрос
            switch response.result {
            case .success(let success):
                // проверка, являются ли данные типом [String: Any]
                guard let data = success as? [String: Any] else { return }
                // проверка, существует ли данные по параметру 'calculate' с типом [String: Any]
                if let calculate = data["calculate"] as? [String: Any] {
                    // проверка, существует ли данные платёжа в месяц с типом [String: Any]
                    guard let monthPay = calculate["monthPay"] as? [String: Any] else { return }
                    // скрыть ошибку стоимости автомобиля и первоначального взноса
                    self.carCostError.isHidden = true
                    self.initialFeeError.isHidden = true
                    // обновить размер cell
                    self.viewController.tableView.beginUpdates()
                    self.viewController.tableView.endUpdates()
                    // установить платёж в месяц
                    self.setMonthPay(monthPay)
                }
                // проверка, существует ли ошибка валидаций с типом [String: Any]
                else if let errorValidation = data["errorValidation"] as? [String: Any] {
                    // проверка, существует ли ошибка стоимости автомобиля с типом String
                    if let userPrice = errorValidation["userPrice"] as? String {
                        // скрыть ошибку первоначального взноса
                        self.initialFeeError.isHidden = true
                        // показать ошибку стоимости автомобиля
                        self.carCostError.isHidden = false
                        // обновить размер cell
                        self.viewController.tableView.beginUpdates()
                        self.viewController.tableView.endUpdates()
                        // установить ошибку стоимости автомобиля
                        self.carCostError.text = userPrice
                    }
                    // проверка, существует ли ошибка первоначального взноса с типом String
                    else if let initPay = errorValidation["initPay"] as? String {
                        // скрыть ошибку стоимости автомобиля
                        self.carCostError.isHidden = true
                        // показать ошибку первоначального взноса
                        self.initialFeeError.isHidden = false
                        // обновить размер cell
                        self.viewController.tableView.beginUpdates()
                        self.viewController.tableView.endUpdates()
                        // установить ошибку первоначального взноса
                        self.initialFeeError.text = initPay
                    }
                }
            case .failure:
                print("error")
            }
        }
    }

    // изменение стоимости автомобиля или первоначального взноса
    @IBAction func inputTextField(_ sender: UITextField) {
        // проверка, существует ли текст
        guard let text = sender.text else { return }
        // проверка, не является ли текст пустым или не равен ли нулю
        guard !text.isEmpty else { return sender.text = "0" }
        // получить цифры (
        guard let digits = Int(text.digits) else { return }
        // установить цифры с разделением по тысячам (1000000 - 1 000 000)
        sender.text = digits.formattedWithSeparator
        
        // проверка, является ли отправитель вводом для цены автомобиля или первоначального взноса
        if sender == carCostTextField {
            // получить стоимость первоначального взноса
            guard let initialFeeDigits = initialFeeTextField.text?.digits else { return }
            guard let initialFee = Int(initialFeeDigits) else { return }
            // получить данные платёжа в месяц по стоимостью автомобиля и первоначального взноса
            getLoan(carCost: digits, initialFee: initialFee)
        } else if sender == initialFeeTextField {
            // получить стоимость автомобиля
            guard let carCostDigits = carCostTextField.text?.digits else { return }
            guard let carCost = Int(carCostDigits) else { return }
            // получить данные платёжа в месяц по стоимостью автомобиля и первоначального взноса
            getLoan(carCost: carCost, initialFee: digits)
        }
    }
    
    // установить платёж в месяц в соответствий с индексом (годом)
    @IBAction func changeMonthPeriodSegmentedControl(_ sender: UISegmentedControl) {
        // проверка, есть ли платёж в месяц в выбранном индексе (годе)
        if let price = monthPay?["\((sender.selectedSegmentIndex + 1) * 12)"] as? Int {
            // установить платёж в месяц с разделением по тысячам (1000000 - 1 000 000)
            monthlyPaymentLabel.text = "  \(price.formattedWithSeparator) ₸  "
        }
    }
}

// MARK: - UITextFieldDelegate
extension LoansTableViewCell: UITextFieldDelegate {
    // ограничение по вводу
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // разрешить ввод только цифр
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if allowedCharacters.isSuperset(of: characterSet) {
            // разрешить ввод не больше 11 символов
            // поэтому максимальной цифрой будет 999 999 999 - 11 символов (включая 2 пробела)
            guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 11
        } else {
            return false
        }
    }
}

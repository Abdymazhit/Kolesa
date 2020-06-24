//
//  AdsViewController.swift
//  Kolesa
//
//  Created by Islam Abdymazhit on 10/05/2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

class AdsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var adIdTextField: UITextField!
    @IBOutlet weak var goToAdButton: UIButton!
    
    // операции перед появлением
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.hidesBackButton = true
        tabBarController?.title = "Объявления"
    }
    
    // операции при загрузке
    override func viewDidLoad() {
        super.viewDidLoad()
        adIdTextField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    // закрыть клавиатуру
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // операции при вводе id объявления
    @IBAction func inputAdIdTextField(_ sender: UITextField) {
        guard let text = sender.text else { return }
        if text.count >= 7 {
            goToAdButton.alpha = 1.0
        } else {
            goToAdButton.alpha = 0.5
        }
    }
    
    // операции при нажатии на кнопку перехода к объявлению
    @IBAction func clickGoToAdButton(_ sender: UIButton) {
        if sender.alpha == 1.0 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Ads", bundle: nil)
            guard let viewController = storyBoard.instantiateViewController(withIdentifier: "AdViewController") as? AdViewController else { return }
            guard let text = adIdTextField.text else { return }
            viewController.id = Int(text)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate
extension AdsViewController: UITextFieldDelegate {
    // ограничение по вводу
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // разрешить ввод только цифр
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if allowedCharacters.isSuperset(of: characterSet) {
            // разрешить ввод не больше 8 символов
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= 9
        } else {
            return false
        }
    }
}


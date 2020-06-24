//
//  KeyboardView.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 22.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UIView для клавиатуры комментариев
@IBDesignable class KeyboardView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var answerForStackView: UIStackView!
    @IBOutlet weak var forAuthorButton: UIButton!
    @IBOutlet weak var nameTextField: KeyboardTextField!
    @IBOutlet weak var commentTextField: KeyboardTextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Private Properties
    private var viewController: UIViewController!
    
    // установить UIViewController для KeyboardView
    func setViewController(_ viewController: UIViewController) {
        self.viewController = viewController
    }
    
    // установить для кого ответ
    func setAnswerFor(_ author: String) {
        forAuthorButton.setTitle(author, for: .normal)
        answerForStackView.isHidden = false
    }
    
    // обработка нажатия на автора для кого ответ
    @IBAction func clickForAuthorButton(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { (action: UIAlertAction) in
            sender.setTitle(nil, for: .normal)
            self.answerForStackView.isHidden = true
            
            // удалить выделение выбранного cell
            if self.viewController is CommentsViewController {
                let viewController = self.viewController as? CommentsViewController
                viewController?.selectedAnswerCell.backgroundColor = .white
                viewController?.selectedAnswerCell = nil
            } else {
                let viewController = self.viewController as? CommentRepliesViewController
                viewController?.selectedAnswerCell.backgroundColor = .white
                viewController?.selectedAnswerCell = nil
            }
            
            self.view.endEditing(true)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        viewController.present(alert, animated: true)
    }
    
    // обработка ввода комментария
    @IBAction func inputCommentTextField(_ sender: UITextField) {
        guard let text  = sender.text else { return }
        if text.count > 3 {
            sendButton.alpha = 1.0
        } else {
            sendButton.alpha = 0.5
        }
    }
    
    // инициализация
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        forAuthorButton.setTitle(nil, for: .normal)
        answerForStackView.isHidden = true
    }
    
    // инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        forAuthorButton.setTitle(nil, for: .normal)
        answerForStackView.isHidden = true
    }
    
    // загрузка UIView из nib
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight
        ]
        
        // добавление тени сверху
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -3)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 1.5
        
        addSubview(view)
        
        self.view = view
    }
}

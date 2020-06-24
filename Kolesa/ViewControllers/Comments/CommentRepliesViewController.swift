//
//  CommentRepliesViewController.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 22.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UITableViewController, который будет показывать ответы к комментарию
class CommentRepliesViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var keyboardView: KeyboardView!
    
    // выбранный cell для ответа
    var selectedAnswerCell: UITableViewCell!
    
    // структура комментария
    private var comment: CommentModel!
    private var isHiddenKeyboard: Bool = true
    private var keyboardSize: CGFloat!
    
    // установить комментарий
    func setComment(_ comment: CommentModel) {
        self.comment = comment
    }
    
    // операции перед появлением
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Ответы к комментарию"
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        if isHiddenKeyboard {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    // операции при загрузке
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // установить UIViewController для KeyboardView
        keyboardView.setViewController(self)
        
        // обработчики для клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // поднять экран при открытии клавиатуры
    @objc func keyboardWillShow(notification: NSNotification) {
        isHiddenKeyboard = false
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 {
                if self.keyboardSize == nil {
                    self.keyboardSize = keyboardSize.height - (UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0)
                }
                
                view.frame.origin.y -= self.keyboardSize
                tableView.contentInset = UIEdgeInsets(top: self.keyboardSize, left: 0, bottom: 0, right: 0)
            }
        }
    }
    
    // понизить экран при закрытии клавиатуры
    @objc func keyboardWillHide(notification: NSNotification) {
        isHiddenKeyboard = true
        if view.frame.origin.y != 0 {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            view.frame.origin.y = 0
        }
    }
}

// MARK: - UITableViewDataSource
extension CommentRepliesViewController: UITableViewDataSource {
    // количество cell = количество подкомментариев + главный комментарий
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment.childs.count + 1
    }
    
    // установка данных для cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = Bundle.main.loadNibNamed("CommentTableViewCell", owner: self, options: nil)?.first as? CommentTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.setAuthor(comment.author)
            cell.setContent(comment.content)
            cell.setDate(comment.date)
            return cell
        } else {
            guard let cell = Bundle.main.loadNibNamed("CommentTableViewCell", owner: self, options: nil)?.first as? CommentTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.setAuthor(comment.childs[indexPath.row - 1].author)
            cell.setContent(comment.childs[indexPath.row - 1].content)
            if let quoteAuthor = comment.childs[indexPath.row - 1].quoteAuthor {
                cell.setQuoteAuthor(quoteAuthor)
            }
            cell.setLeftInset(20)
            cell.setDate(comment.childs[indexPath.row - 1].date)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension CommentRepliesViewController: UITableViewDelegate {
    // обработка нажатия на cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isHiddenKeyboard {
            view.endEditing(true)
        } else {
            // отобразить UIAlertController для действий с комментарием
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let answerAction = UIAlertAction(title: "Ответить", style: .default) { (action: UIAlertAction) in
                if self.selectedAnswerCell != nil {
                    self.selectedAnswerCell.backgroundColor = .white
                }
                self.selectedAnswerCell = tableView.cellForRow(at: indexPath)
                self.clickAnswerButton(indexPath: indexPath)
            }
            
            let reportAction = UIAlertAction(title: "Пожаловаться", style: .destructive) { (action: UIAlertAction) in
                
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            
            alert.addAction(answerAction)
            alert.addAction(reportAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - CommentsCellDelegate
extension CommentRepliesViewController: AnswerCommentProtocol {
    // обработка нажатия на кнопку ответить
    func clickAnswerButton(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if selectedAnswerCell != nil {
            selectedAnswerCell.backgroundColor = .white
        }
        selectedAnswerCell = cell
        clickAnswerButton(indexPath: indexPath)
    }
    
    
    func clickAnswerButton(indexPath: IndexPath) {
        if indexPath.row - 1 >= 0 {
            keyboardView.setAnswerFor(comment.childs[indexPath.row - 1].author)
        } else {
            keyboardView.setAnswerFor(comment.author)
        }
        
        keyboardView.commentTextField.becomeFirstResponder()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        selectedAnswerCell.backgroundColor = UIColor.link.withAlphaComponent(0.2)
    }
}

//
//  CommentsViewController.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 31.05.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UIViewController для комментариев объявления
class CommentsViewController: UIViewController {
    
    // 'id' объявления
    var id: Int!
    // выбранный cell для ответа
    var selectedAnswerCell: UITableViewCell!
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var keyboardView: KeyboardView!
    
    // MARK: - Private Properties
    private var viewModel: CommentsViewModel!
    private var isHiddenKeyboard: Bool = true
    private var keyboardSize: CGFloat!
    
    // операции перед появлением
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // проверить, существует ли 'id' объявления
        if let id = id {
            title = "Комментария"
            navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            navigationController?.navigationBar.shadowImage = nil
            navigationController?.navigationBar.tintColor = .black
            navigationController?.navigationBar.barStyle = .default
            navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

            if isHiddenKeyboard {
                tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            
            // проверить, существует ли viewModel
            if viewModel == nil {
                // инициализировать и получить данные из viewModel
                viewModel = CommentsViewModel(id: id)
                viewModel.fetchData(completion: { (result) in
                    // проверить, успешно ли прошёл запрос
                    switch result {
                    case .success:
                        // обновить данные
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
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
    
    // операции при загрузке
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // установить UIViewController для KeyboardView
        keyboardView.setViewController(self)
        
        // обработчики для клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // поднять экран при открытии клавиатуры
    @objc func keyboardWillShow(notification: NSNotification) {
        isHiddenKeyboard = false
        if view.frame.origin.y == 0 {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
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
    
    // переход на предыдущий UIViewController с ошибкой AlertView
    @objc func popViewControllerWithError() {
        let alert = UIAlertController(title: "Комментария отключены", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Окей", style: .default) { (action: UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension CommentsViewController: UITableViewDataSource {
    // количество секции = количество комментариев
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.comments.count
    }
    
    // количество cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // проверить, больше ли подкомментария чем 2
        // если больше, вернуть 4 cell, т.к. 1 элемент - главный комментарий, 2-3 - подкомментария, 4 - кнопка посмотреть все комментария
        if viewModel.comments[section].childs.count > 2 {
            return 4
        } else {
            return viewModel.comments[section].childs.count + 1
        }
    }
    
    // установка данных для cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = Bundle.main.loadNibNamed("CommentTableViewCell", owner: self, options: nil)?.first as? CommentTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.setAuthor(viewModel.comments[indexPath.section].author)
            cell.setContent(viewModel.comments[indexPath.section].content)
            cell.setDate(viewModel.comments[indexPath.section].date)
            return cell
        } else if indexPath.row == 1 || indexPath.row == 2 {
            guard let cell = Bundle.main.loadNibNamed("CommentTableViewCell", owner: self, options: nil)?.first as? CommentTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.setAuthor(viewModel.comments[indexPath.section].childs[indexPath.row - 1].author)
            cell.setContent(viewModel.comments[indexPath.section].childs[indexPath.row - 1].content)
            if let quoteAuthor = viewModel.comments[indexPath.section].childs[indexPath.row - 1].quoteAuthor {
                cell.setQuoteAuthor(quoteAuthor)
            }
            cell.setLeftInset(20)
            cell.setDate(viewModel.comments[indexPath.section].childs[indexPath.row - 1].date)
            return cell
        } else {
            guard let cell = Bundle.main.loadNibNamed("ViewAllCommentsTableViewCell", owner: self, options: nil)?.first as? ViewAllCommentsTableViewCell else { return UITableViewCell() }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension CommentsViewController: UITableViewDelegate {
    // обработка нажатия на cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isHiddenKeyboard {
            view.endEditing(true)
        } else {
            // переход в UIViewController для отображения всех ответов на комментарий
            if tableView.cellForRow(at: indexPath) is ViewAllCommentsTableViewCell {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Comments", bundle: nil)
                guard let commentRepliesViewController = storyBoard.instantiateViewController(withIdentifier: "CommentRepliesViewController") as? CommentRepliesViewController else { return }
                commentRepliesViewController.setComment(viewModel.comments[indexPath.section])
                navigationController?.pushViewController(commentRepliesViewController, animated: true)
            }
                // отобразить UIAlertController для действий с комментарием
            else {
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
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - CommentsCellDelegate
extension CommentsViewController: AnswerCommentProtocol {
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
            keyboardView.setAnswerFor(viewModel.comments[indexPath.section].childs[indexPath.row - 1].author)
        } else {
            keyboardView.setAnswerFor(viewModel.comments[indexPath.section].author)
        }
        
        keyboardView.commentTextField.becomeFirstResponder()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        selectedAnswerCell.backgroundColor = UIColor.link.withAlphaComponent(0.2)
    }
}

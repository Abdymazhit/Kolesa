//
//  CommentsTableViewCell.swift
//  Kolesa
//
//  Created by Islam Abdymazhit on 11/05/2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UITableViewCell для показа комментариев объявления
class CommentsCountTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var commentsButton: UIButton!
    // UIViewController, через который будет реализован pushViewController
    private var viewController: AdViewController!
    
    // установить данные
    func setViewController(_ viewController: AdViewController) {
        self.viewController = viewController
    }
    
    // установить текст, показывающий количество комментариев объявления
    func setCommentsCount(_ commentsCount: Int) {
        // создать окончание
        // установить текст, показывающий количество комментариев
        let last = commentsCount % 10
        if last == 1 {
            commentsButton.setTitle("\(String(commentsCount)) комментарий", for: .normal)
        } else if last >= 2 && last <= 4 {
            commentsButton.setTitle("\(String(commentsCount)) комментария", for: .normal)
        } else {
            commentsButton.setTitle("\(String(commentsCount)) комментариев", for: .normal)
        }
    }
    
    // перейти в UIViewController, который показывает комментария
    @IBAction func clickCommentsButton(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Comments", bundle: nil)
        guard let commentsViewController = storyBoard.instantiateViewController(withIdentifier: "CommentsViewController") as? CommentsViewController else { return }
        commentsViewController.id = viewController.id
        viewController.navigationController?.pushViewController(commentsViewController, animated: true)
    }
    
}

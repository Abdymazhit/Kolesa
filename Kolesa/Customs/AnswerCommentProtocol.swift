//
//  AnswerCommentProtocol.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 23.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// протокол для отслежки нажатия кнопки ответить
protocol AnswerCommentProtocol: AnyObject {
    func clickAnswerButton(cell: UITableViewCell)
}

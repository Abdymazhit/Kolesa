//
//  CommentTableViewCell.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 21.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import UIKit

// UIView для показа комментария
@IBDesignable class CommentTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    
    // MARK: - Private Properties
    private var leftInset: CGFloat = 0
    
    // протокол для отслежки нажатия кнопки ответить
    weak var delegate: AnswerCommentProtocol?
    
    // установить автора комментария
    func setAuthor(_ author: String) {
        authorLabel.text = author
    }
    
    // установить контент комментария
    func setContent(_ content: String) {
        contentTextView.text = content
    }
    
    // установить отступ слева для cell
    func setLeftInset(_ leftInset: CGFloat) {
        self.leftInset = leftInset
    }
    
    // изменить цвет автора цитаты
    func setQuoteAuthor(_ quoteAuthor: String) {
        guard let regex = try? NSRegularExpression(pattern: quoteAuthor, options: []) else { return }
        
        let attrStr = NSMutableAttributedString(attributedString: contentTextView.attributedText ?? NSAttributedString())
        let plainStr = attrStr.string
        attrStr.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(0..<plainStr.utf16.count))
    
        let matches = regex.matches(in: plainStr, range: NSRange(0..<plainStr.utf16.count))
        
        for match in matches {
            attrStr.addAttribute(.foregroundColor, value: UIColor.link, range: match.range)
        }
        
        contentTextView.attributedText = attrStr
    }
    
    // установить дату комментария
    func setDate(_ date: String) {
        dateLabel.text = date
    }
    
    // передать нажатие в UIViewController
    @IBAction func clickAnswerButton(_ sender: UIButton) {
        delegate?.clickAnswerButton(cell: self)
    }
    
    // установить отступы для UITextView
    override func awakeFromNib() {
        super.awakeFromNib()
        let padding = contentTextView.textContainer.lineFragmentPadding
        contentTextView.textContainerInset =  UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
    }
    
    // установить отступы для cell
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 0))
    }
}

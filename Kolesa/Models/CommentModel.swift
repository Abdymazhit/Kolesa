//
//  CommentModel.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 31.05.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import Foundation

struct CommentModel {
    
    let author: String
    let date: String
    let content: String
    var childs: [CommentModel]
    
    var quoteAuthor: String?
    var quote: String?
    
    init(author: String, date: String, content: String, childs: [CommentModel], quoteAuthor: String?, quote: String?) {
        self.author = author
        self.date = date
        self.content = content
        self.childs = childs
        self.quoteAuthor = quoteAuthor
        self.quote = quote
    }
}

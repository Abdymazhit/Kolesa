//
//  CommentsViewModel.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 19.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import Foundation

class CommentsViewModel {
    
    // MARK: - Private Properties
    private var id: Int
    private var ad: Ad!
    
    // MARK: - Properties
    var comments: [CommentModel]!
    
    // MARK: - Init
    init(id: Int) {
        self.id = id
    }
    
    // MARK: - получить данные
    func fetchData(completion: @escaping (Result<[CommentModel]?, ParseError>) -> Void) {
        // инициализация класса парсинга страницы объявления
        let parse = ParseComments()
    
        // получить HTML документ по url
        Parse.shared.getHTMLDocument("https://kolesa.kz/comment/ajax-comments/\(id)/", completion: { result in
            // проверить, успешно ли прошёл запрос
            switch result {
            case .success(let doc):
                // пропарсить остальные данные
                guard let comments = parse.getComments(doc) else { return completion(.failure(.noCommentsData)) }
                self.comments = comments
                completion(.success(comments))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

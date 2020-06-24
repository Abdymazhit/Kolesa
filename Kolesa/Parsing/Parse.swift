//
//  Parse.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 31.05.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import Kanna
import Alamofire

// класс для работы с парсингом
class Parse {
    
    static let shared: Parse = Parse()
    
    // получение html документа для парсинга
    func getHTMLDocument(_ url: String, completion: @escaping (Result<HTMLDocument, ParseError>) -> Void) {
        // делаем запрос по url
        AF.request(url).responseString { response in
            // проверить, успешно ли прошёл запрос
            switch response.result {
            case .success:
                // получение html от url и преобразование его в html документ
                guard let html = response.value else { return completion(.failure(.invalidHtml)) }
                guard let document = try? HTML(html: html, encoding: .utf8) else { return completion(.failure(.invalidDocument)) }
                completion(.success(document))
            case .failure:
                // ошибка в url
                completion(.failure(.invalidUrl))
            }
        }
    }
}

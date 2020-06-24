//
//  ParseComments.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 20.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import Kanna

// парсинг страницы комментариев объявления
class ParseComments {
    
    // MARK: получить комментария
    func getComments(_ doc: HTMLDocument) -> [CommentModel]? {
        // проверить отключены ли комментария у объявления
        guard let text = doc.text else { return nil }
        if !text.contains("Комментарии отключены") {
            // создать массив с комментариями
            var comments = [CommentModel]()
            
            // перебор комментария
            for data in doc.css("div[class='comment']") {
                // проверить, есть ли автор, дата и текст комментария
                guard let author = data.css("div[class='comment-author']").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
                guard let date = data.css("span[class='comment-date']").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return nil }
                
                // создать массив с текстом
                var content = [String]()
                
                // проверить, есть ли текст
                if let textElement = data.css("div[class='comment-text clearfix ']").first {
                    // перебор текста
                    for commentContent in textElement.xpath("node()") {
                        // проверить, является ли текст ссылкой
                        if let href = commentContent["href"] {
                            // добавить в массив ссылку
                            content.append(String("https://kolesa.kz\(href)").trimmingCharacters(in: .whitespacesAndNewlines))
                        }
                        // проверить, является ли текст рекламой
                        else if let advert = commentContent.at_xpath("div") {
                            // добавить в массив ссылку на рекламу
                            if let link = getAdvertLinkFromComment(element: advert) {
                                content.append(link)
                            }
                        }
                        // проверить, является ли текст обычным
                        else {
                            // добавить в массив текст
                            guard let commentText = commentContent.text else { return nil }
                            content.append(String(commentText).trimmingCharacters(in: .whitespacesAndNewlines).filter { !"\n\t\r".contains($0) })
                        }
                    }
                } else if let textElement = data.css("div[class='comment-text clearfix  owner']").first {
                    // перебор текста
                    for commentContent in textElement.xpath("node()") {
                        // проверить, является ли текст ссылкой
                        if let href = commentContent["href"] {
                            // добавить в массив ссылку
                            content.append(String("https://kolesa.kz\(href)").trimmingCharacters(in: .whitespacesAndNewlines))
                        }
                        // проверить, является ли текст рекламой
                        else if let advert = commentContent.at_xpath("div") {
                            // добавить в массив ссылку на рекламу
                            if let link = getAdvertLinkFromComment(element: advert) {
                                content.append(link)
                            }
                        }
                        // проверить, является ли текст обычным
                        else {
                            // добавить в массив текст
                            guard let commentText = commentContent.text else { return nil }
                            content.append(String(commentText).trimmingCharacters(in: .whitespacesAndNewlines).filter { !"\n\t\r".contains($0) })
                        }
                    }
                } else {
                    return nil
                }
                
                // убрать из массива пустые тексты
                content = content.filter({ $0 != ""})
                
                // создать комментарий с значениями по умолчанию
                var comment = CommentModel(author: author, date: date, content: content.joined(separator: " "), childs: [], quoteAuthor: nil, quote: nil)
                
                // проверить, есть ли цитата у комментария
                // если нету, то сообщение не является ответом
                if let quote = data.css("span[class='quote']").first {
                    // проверить, есть ли подкомментария у комментария
                    // если нету, то сообщение не является ответом
                    if data.css("div[class='comment-childs']").first == nil {
                        // получить подкомментария (автор цитаты, цитата)
                        let quoteString = quote.css("div").first?.text?.trimmingCharacters(in: .whitespacesAndNewlines).filter { !"\n\t\r".contains($0) }
                    
                        // получить автора цитаты
                        if let quoteAuthor = quoteString?.components(separatedBy: " ").first {
                            // получить текст цитаты
                            if let quoteText = quoteString?.replacingOccurrences(of: String(quoteAuthor), with: "", options: .literal, range: nil).trimmingCharacters(in: .whitespacesAndNewlines) {
                                // установить значения
                                comment.quoteAuthor = quoteAuthor
                                comment.quote = quoteText
                                // добавить подкомментарий в массив подкомментария предыдущего комментария
                                // т.к. если этот комментарии является подкомментарием, тогда предыдущий комментарии имеет массив с подкомментариями
                                if comments.count != 0 {
                                    comments[comments.count - 1].childs.append(comment)
                                }
                            }
                        }
                    } else {
                        comments.append(comment)
                    }
                } else {
                    comments.append(comment)
                }
            }
            
            // вернуть массив с комментариями
            return comments
        } else {
            return nil
        }
    }
    
    // MARK: получить ссылку на рекламу из комментария
    func getAdvertLinkFromComment(element: XMLElement) -> String? {
        // получить фотографию рекламы
        guard let advertPhoto = element.css("div[class='preview-photo']").first else { return nil }
        // получить первый 'a' элемент
        guard let a = advertPhoto.css("a").first else { return nil }
        // получить id рекламы
        guard let id = a["href"]?.digits else { return nil }
        // вернуть ссылку на рекламу
        return "https://kolesa.kz/a/show/\(id)"
    }
}

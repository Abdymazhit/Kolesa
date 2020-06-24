//
//  ParseError.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 01.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import Foundation

// ошибки парсинга
enum ParseError: Error {
    case invalidUrl
    case invalidHtml
    case invalidDocument
    
    case noImagesData
    case noTitleData
    case noInfoData
    
    case noAdsViewedData
    case noCommentsData
}

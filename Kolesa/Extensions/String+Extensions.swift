//
//  String+Extensions.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 01.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import Foundation

extension String {
    // вернуть только цифры от строки
    var digits: String {
        let characterSet = CharacterSet(charactersIn: "0123456789.").inverted
        return components(separatedBy: characterSet).joined()
    }
}

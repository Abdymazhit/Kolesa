//
//  Numeric+Extensions.swift
//  Kolesa
//
//  Created by Abdymazhit Islam on 01.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import Foundation

extension Numeric {
    // разделитель Int по тысячам (1000000 - 1 000 000)
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter.string(for: self) ?? ""
    }
}

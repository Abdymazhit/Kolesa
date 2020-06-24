//
//  SupportingInfoTableViewCellTests.swift
//  KolesaTests
//
//  Created by Abdymazhit Islam on 23.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import XCTest

class SupportingInfoTableViewCellTests: XCTestCase {

    func testFormattedDateIsCorrect() {
        let publicationDate = "2020-06-24T23:59:59+06:00"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: publicationDate) {
            dateFormatter.dateFormat = "dd MMMM YYYY"
            let stringDate = dateFormatter.string(from: date)
            XCTAssertTrue(stringDate == "24 июня 2020")
        }
    }

}

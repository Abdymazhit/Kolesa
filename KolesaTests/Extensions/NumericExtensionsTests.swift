//
//  NumericExtensionsTests.swift
//  KolesaTests
//
//  Created by Abdymazhit Islam on 23.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import XCTest

@testable import Kolesa

class NumericExtensionsTests: XCTestCase {

    func testIsFormattedWithSeparator() {
        let testInt = 1234567
        XCTAssertTrue(testInt.formattedWithSeparator == "1 234 567")
    }
}

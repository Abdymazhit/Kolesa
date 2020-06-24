//
//  StringExtensionsTests.swift
//  KolesaTests
//
//  Created by Abdymazhit Islam on 23.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import XCTest

@testable import Kolesa

class StringExtensionsTests: XCTestCase {

    func testDigits() {
        let testString = "a1 b2 b3"
        XCTAssertTrue(testString.digits == "123")
    }
}

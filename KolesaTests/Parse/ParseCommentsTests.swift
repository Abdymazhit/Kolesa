//
//  ParseCommentsTests.swift
//  KolesaTests
//
//  Created by Abdymazhit Islam on 23.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import XCTest

@testable import Kolesa
@testable import Kanna

class ParseCommentsTests: XCTestCase {

    private var parse: ParseComments!
    private var commentsDoc: HTMLDocument!
    
    override func setUp() {
        super.setUp()
        parse = ParseComments()
        commentsDoc = try! HTML(html: TestHTML.commentsHTML, encoding: .utf8)
        XCTAssertNotNil(commentsDoc)
    }
    
    override func tearDown() {
        super.tearDown()
        parse = nil
        commentsDoc = nil
    }
    
    func testGetCommentsIsWorkingCorrect() {
        let comments = parse.getComments(commentsDoc)
        XCTAssertEqual(comments?.count, 2)
    }
}

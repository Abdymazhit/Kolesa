//
//  AdViewModelTests.swift
//  KolesaTests
//
//  Created by Abdymazhit Islam on 23.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import XCTest

@testable import Kolesa
@testable import Kanna

class AdViewModelTests: XCTestCase {
    
    private var doc: HTMLDocument!
    
    override func setUp() {
        super.setUp()
        doc = try! HTML(html: TestHTML.adHTML, encoding: .utf8)
        XCTAssertNotNil(doc)
    }
    
    override func tearDown() {
        super.tearDown()
        doc = nil
    }
    
    func testHTMLDocumentHasMasterData() {
        for script in doc.css("script") {
            if script.text!.contains("window.digitalData") {
                let data = script.text!.components(separatedBy: " if")[0].components(separatedBy: "window.digitalData = ")[1].replacingOccurrences(of: ";", with: "")
                print(data)
                XCTAssertNotNil(data)
                testJSONDecoderIsWorkingCorrect(data: data)
            }
        }
    }
    
    func testJSONDecoderIsWorkingCorrect(data: String) {
        let jsonData = Data(data.utf8)
        let ad = try! JSONDecoder().decode(Ad.self, from: jsonData)
        XCTAssertNotNil(ad)
        testAdDataIsCorrect(ad: ad)
    }
    
    func testAdDataIsCorrect(ad: Ad) {
        XCTAssertEqual(ad.product.id, 104131830)
        XCTAssertEqual(ad.product.name, "Toyota Highlander  2012 года")
        XCTAssertEqual(ad.product.unitPrice, 10500000)
        XCTAssertEqual(ad.product.attributes.avgPrice, 11301000)
        XCTAssertEqual(ad.product.isCreditAvailable, true)
        XCTAssertEqual(ad.product.photoCount, 17)
        XCTAssertEqual(ad.product.commentsCount, 2)
        XCTAssertEqual(ad.product.publicationDate, "2020-06-24T11:53:48+06:00")
    }
}

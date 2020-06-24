//
//  ParseAdTests.swift
//  KolesaTests
//
//  Created by Abdymazhit Islam on 23.06.2020.
//  Copyright © 2020 Kolesa Group. All rights reserved.
//

import XCTest

@testable import Kolesa
@testable import Kanna

class ParseAdTests: XCTestCase {
    
    private var parse: ParseAd!
    private var adDoc: HTMLDocument!
    private var adsViewedDoc: HTMLDocument!
    
    override func setUp() {
        super.setUp()
        parse = ParseAd()
        adDoc = try! HTML(html: TestHTML.adHTML, encoding: .utf8)
        adsViewedDoc = try! HTML(html: TestHTML.adsViewedHTML, encoding: .utf8)
        XCTAssertNotNil(adDoc)
        XCTAssertNotNil(adsViewedDoc)
    }
    
    override func tearDown() {
        super.tearDown()
        parse = nil
        adDoc = nil
        adsViewedDoc = nil
    }
    
    func testGetImagesIsWorkingCorrect() {
        let images = parse.getImages(adDoc)
        XCTAssertEqual(images?.count, 17)
    }
    
    func testGetInfoDataIsWorkingCorrect() {
        let infoData = parse.getInfoData(adDoc)
        XCTAssertEqual(infoData?.count, 9)
    }
    
    func testGetOptionsAndSpecificationsIsWorkingCorrect() {
        let (options, specifications) = parse.getOptionsAndSpecifications(adDoc)
        XCTAssertEqual(options?.count, 350)
        XCTAssertEqual(specifications?.count, 132)
    }
    
    func testGetPromotionIsWorkingCorrect() {
        let promotion = parse.getPromotion(adDoc)
        XCTAssertEqual(promotion?.count, 4)
    }
    
    func testGetSparesIsWorkingCorrect() {
        let spares = parse.getSpares(adDoc)
        XCTAssertEqual(spares?.count, 4)
    }
    
    func testGetSimilarIsWorkingCorrect() {
        let similar = parse.getSimilar(adDoc)
        XCTAssertEqual(similar?.count, 4)
    }
    
    func testGetAdsViewedIsWorkingCorrect() {
        let adsViewed = parse.getAdsViewed(adsViewedDoc)
        XCTAssertEqual(adsViewed, 1061)
    }
}

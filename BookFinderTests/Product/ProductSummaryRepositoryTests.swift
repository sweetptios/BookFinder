//
//  ProductSummaryRepositoryTests.swift
//  cosmeticsTests
//
//  Created by mine on 2020/01/18.
//  Copyright © 2020 sweetptdev. All rights reserved.
//

import XCTest
@testable import BookFinder
import Stubber
import Nimble

class ProductSummaryRepositoryTests: XCTestCase {

    var repository: IBookSummaryRepository!
    let networkingStub = NetworkingServiceStub()
    
    override func setUp() {
       
        repository = ProductSummaryRepository(networking: networkingStub)
    }

    override func tearDown() {}

    func test_상품목록을요청했을때_성공하면_데이터를전달한다() {
        // [given]
        networkingStub.setSuccess(true)
        // [when]
        let dummyPage = 0
        let dummyKeyword = ""
        repository.fetchBooks(page: dummyPage, keyword: dummyKeyword) { (result) in
            // [then]
            switch(result) {
            case .success:
                XCTAssert(true)
            default:
                XCTAssert(false, "test failed")
            }
        }
    }
    
    func test_상품목록을요청했을때_실패하면_에러를전달한다() {
        // [given]
        networkingStub.setSuccess(false)
        // [when]
        let dummyPage = 0
        let dummyKeyword = ""
        repository.fetchBooks(page: dummyPage, keyword: dummyKeyword) { (result) in
            // [then]
            switch(result) {
            case .success:
                XCTAssert(false, "test failed")
            default:
                XCTAssert(true)
            }
        }
    }
}

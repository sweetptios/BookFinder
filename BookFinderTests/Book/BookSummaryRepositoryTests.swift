//
//  BookSummaryRepositoryTests.swift
//  cosmeticsTests
//
//  Created by mine on 2020/02/05.
//  Copyright © 2020 sweetptdev. All rights reserved.
//

import XCTest
@testable import BookFinder
import Stubber
import Nimble

class BookSummaryRepositoryTests: XCTestCase {

    var repository: IBookSummaryRepository!
    let networkingStub = NetworkingServiceStub()
    
    override func setUp() {
        repository = BookSummaryRepository(networking: networkingStub)
    }

    override func tearDown() {}

    func test_책목록을요청했을때_성공하면_목록과총개수를전달한다() {
        // [given]
        networkingStub.setSuccess(true)
        networkingStub.setResultJson("""
            {
                "totalItems": 4,
                "items": [
                    {
                        "volumeInfo": {
                            "title": "a"
                        }
                    },
                    {
                        "volumeInfo": {
                            "title": "b"
                        }
                    }
                ]
            }
        """)
        let testTotalCount = 4
        let testBooks = [ Book(title: "a"), Book(title: "b") ]
        // [when]
        let dummyPage = 0
        let dummyKeyword = ""
        let dummyMaxResultCount = 0
        let ex = XCTestExpectation(description: "test")
        repository.fetchBooks(page: dummyPage, keyword: dummyKeyword, maxResultCount: dummyMaxResultCount) { (result) in
            // [then]
            switch(result) {
            case let .success(data):
                expect(data.books[0].title).to(equal(testBooks[0].title))
                expect(data.books[1].title).to(equal(testBooks[1].title))
                expect(data.totalCount).to(equal(testTotalCount))
                XCTAssert(true)
            case .failure(let error):
                XCTAssert(false, "test failed: error - \(error)")
            }
            ex.fulfill()
        }
        _ = XCTWaiter.wait(for: [ex], timeout: 0.01)
    }

    func test_책목록을요청했을때_검색결과가없으면_에러를전달한다() {
        // [given]
        networkingStub.setSuccess(true)
        networkingStub.setResultJson("""
            {
              "items": []
            }
        """)
        let keyword = "test"
        // [when]
        let dummyPage = 0
        let dummyMaxResultCount = 0
        let ex = XCTestExpectation(description: "in closure")
        repository.fetchBooks(page: dummyPage, keyword: keyword, maxResultCount: dummyMaxResultCount) { (result) in
            // [then]
            switch(result) {
            case .success:
                XCTAssertTrue(false)
            case let .failure(error):
                expect(error.kind).to(equal(RepositoryError.ErrorKind.emptySearchResult(keyword: keyword)))
            }
            ex.fulfill()
        }
        _ = XCTWaiter.wait(for: [ex], timeout: 0.01)
    }

    func test_책목록을요청했을때_실패하면_에러를전달한다() {
        // [given]
        networkingStub.setSuccess(false)
        // [when]
        let dummyPage = 0
        let dummyKeyword = ""
        let dummyMaxResultCount = 0
        let ex = XCTestExpectation(description: "test")
        repository.fetchBooks(page: dummyPage, keyword: dummyKeyword, maxResultCount: dummyMaxResultCount) { (result) in
            // [then]
            switch(result) {
            case .success:
                XCTAssertTrue(false)
            case .failure:
                XCTAssert(true)
            }
            ex.fulfill()
        }
        _ = XCTWaiter.wait(for: [ex], timeout: 0.01)
    }
}

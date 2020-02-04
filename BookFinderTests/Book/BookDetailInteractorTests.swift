//
//  BookDetailInteractorTests.swift
//  BookFinderTests
//
//  Created by GOOK HEE JUNG on 2020/02/03.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import XCTest
@testable import BookFinder
import Stubber
import Nimble

class BookDetailInteractorTests: XCTestCase {

    var interactor: BookDetailInputBoundary!
    var outputBoundaryMock: BookDetailOutputBoundaryMock!

    override func setUp() {
        outputBoundaryMock = BookDetailOutputBoundaryMock()
        let dummyItemId = "a"
        let dummyDetailInfoUrl = URL(string: "")
        interactor = BookDetailInteractor(outputBoundary: outputBoundaryMock, itemId: dummyItemId, detailInfoUrl: dummyDetailInfoUrl)
    }

    override func tearDown() {}
    
    func test_상세페이지로드를요청했을때_웹페이지를보여준다() {
        // [given]
        Stubber.register(outputBoundaryMock.showBookDetail) { _ in }
        let dummyItemId = "a"
        let url = URL(string: "https://test.com")
        interactor = BookDetailInteractor(outputBoundary: outputBoundaryMock, itemId: dummyItemId, detailInfoUrl: url)
        // [when]
        interactor.viewDidLoad()
        // [then]
        let f = Stubber.executions(self.outputBoundaryMock.showBookDetail)
        expect(f[0].arguments).to(equal(url))
    }
}

//
//  BookDetailPresenterTests.swift
//  BookFinderTests
//
//  Created by GOOK HEE JUNG on 2020/02/03.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import XCTest
@testable import BookFinder
import Stubber
import Nimble

class BookDetailPresenterTests: XCTestCase {

    var presenter: BookDetailPresenter!
    var viewMock: BookDetailViewMock!
    
    override func setUp() {
        viewMock = BookDetailViewMock()
        presenter = BookDetailPresenter()
        presenter.setView(viewMock)
    }

    override func tearDown() {}

    func test_책상세정보를보여줄수있다() {
        // [given]
        Stubber.register(viewMock.showBookDetail) { _ in }
        let url = URL(string: "https://test.com")
        // [when]
        presenter.showBookDetail(url)
        // [then]
        let f = Stubber.executions(self.viewMock.showBookDetail)
        expect(f[0].arguments).to(equal(url))
    }

}

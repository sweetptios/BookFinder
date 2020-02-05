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

    func test_원하는페이지로이동할수있다() {
        // [given]
        Stubber.register(viewMock.loadWebPage) { _ in }
        let url = URL(string: "https://test.com")
        // [when]
        presenter.goToWebPage(url!)
        // [then]
        let f = Stubber.executions(self.viewMock.loadWebPage)
        expect(f[0].arguments).to(equal(url))
    }

    
    func test_이전페이지를보여준다() {
        // [given]
        Stubber.register(viewMock.goBackToPrevWebPage) { _ in }
        // [when]
        presenter.goBackToPrevWebPage()
        // [then]
        expect(Stubber.executions(self.viewMock.goBackToPrevWebPage).count).to(equal(1))
    }
    
    func test_다음페이지를보여준다() {
        // [given]
        Stubber.register(viewMock.goForwardToNextWebPage) { _ in }
        // [when]
        presenter.goForwardToNextWebPage()
        // [then]
        expect(Stubber.executions(self.viewMock.goForwardToNextWebPage).count).to(equal(1))
    }
    
    func test_현재페이지를리로드해준다() {
        // [given]
        Stubber.register(viewMock.reloadWebPage) { _ in }
        // [when]
        presenter.reloadWebPage()
        // [then]
        expect(Stubber.executions(self.viewMock.reloadWebPage).count).to(equal(1))
    }
    
    func test_이전화면으로돌아갈수있다() {
        // [given]
        Stubber.register(viewMock.exit) { _ in }
        // [when]
        presenter.exit()
        // [then]
        expect(Stubber.executions(self.viewMock.exit).count).to(equal(1))
    }
}

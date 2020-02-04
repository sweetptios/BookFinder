//
//  ProductIndexPresenterTests.swift
//  cosmeticsTests
//
//  Created by mine on 2020/01/15.
//  Copyright © 2020 sweetptdev. All rights reserved.
//

import XCTest
@testable import BookFinder
import Stubber
import Nimble

class ProductIndexPresenterTests: XCTestCase {

    var presenter: ProductIndexPresenter!
    var viewMock: ProductIndexViewMock!
    
    override func setUp() {
        viewMock = ProductIndexViewMock()
        presenter = ProductIndexPresenter()
        presenter.setView(viewMock)
    }

    override func tearDown() {}
    
    func test_책리스트를보여줄수있다() {
        // [given]
        Stubber.register(viewMock.showProducts) { _ in }
        let date = Date()
        let displayedDate = date.string(format: "yyyy-MM-dd")
        let book1 = ProductSummary(from: Book(id: "akjldf", title: "TDD 시작하기",authors: ["Hannah","Ashley"], publishedDate: date, thumbnailImage: URL(string: "http://picture.com/thumb/1")))
        let displayedAuthor = "\(book1.authors.first ?? "")외 \(book1.authors.count)명"
        let viewData1 = ProductIndexCollectionItemViewData(id: book1.id, thumbnailUrl: book1.thumbnailImage, title: book1.title, author: displayedAuthor, publishedDate: displayedDate)
        // [when]
        presenter.showProducts([book1])
        // [then]
        let f = Stubber.executions(self.viewMock.showProducts)
        let list = f[0].arguments
            
        expect(list[0].id).to(equal(viewData1.id))
        expect(list[0].title).to(equal(viewData1.title))
        expect(list[0].author).to(equal(viewData1.author))
        expect(list[0].thumbnailUrl).to(equal(viewData1.thumbnailUrl))
        expect(list[0].publishedDate).to(equal(viewData1.publishedDate))
    }
    
    #warning("TODO - 이름이 이상하다")
    func test_로딩인디케이터를보여줄수있다() {
        // [given]
        Stubber.register(viewMock.showLoadingIndicator) { _ in }
        // [when]
        presenter.showLoadingIndicator()
        // [then]
        expect(Stubber.executions(self.viewMock.showLoadingIndicator).count).to(equal(1))
    }
    
    func test_로딩인디케이터를숨길수있다() {
        // [given]
        Stubber.register(viewMock.hideLoadingIndicator) { _ in }
        // [when]
        presenter.hideLoadingIndicator()
        // [then]
        expect(Stubber.executions(self.viewMock.hideLoadingIndicator).count).to(equal(1))
    }
    
    func test_검색어를보여줄수있다() {
        // [given]
        Stubber.register(viewMock.showSearchKeyword) { _ in }
        let keyword = "test"
        // [when]
        presenter.showSearchKeyword(keyword)
        // [then]
        let f = Stubber.executions(self.viewMock.showSearchKeyword)
        expect(f[safe: 0]?.arguments).to(equal(keyword))
    }

    
    func test_맨앞으로스크롤할수있다() {
        // [given]
        Stubber.register(viewMock.scrollToTop) { _ in }
        // [when]
        presenter.scrollToTop()
        // [then]
        expect(Stubber.executions(self.viewMock.scrollToTop).count).to(equal(1))
    }
    
    func test_전체책개수를보여줄수있다() {
        // [given]
        Stubber.register(viewMock.showTotalCount) { _ in }
        let count = 10
        #warning("TODO - 하드코딩으로 하지 않을 방법이 없을까")
        let countString = "Result: (\(count))"
        // [when]
        presenter.showTotalCount(count)
        // [then]
        let f = Stubber.executions(self.viewMock.showTotalCount)
        expect(f[safe: 0]?.arguments).to(equal(countString))
    }
}

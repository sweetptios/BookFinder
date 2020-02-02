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

    var presenter: (IProductIndexPresenter & ProductIndexOutputBoundary)!
    var interactorMock: ProductIndexInteractorMock!
    var viewMock: ProductIndexViewMock!
    
    override func setUp() {
        viewMock = ProductIndexViewMock()
        let dummyNetworking = NetworkingSeriveMock()
        let dummyRepository = ProductSummaryRepositoryMock(networking: dummyNetworking)
        presenter = ProductIndexPresenter(view: viewMock)
        interactorMock = ProductIndexInteractorMock(outputBoundary: presenter, repository: dummyRepository)
        presenter.setInteractor(interactorMock)
    }

    override func tearDown() {}
    
    func test_특정상품을선택했을때_상품상세화면으로이동한다() {
        // [given]
        Stubber.register(interactorMock.didSelectProduct) { _ in }
        // [when]
        let dummyIndex = 0
        presenter.didSelectProduct(index: dummyIndex)
        // [then]
        expect(Stubber.executions(self.interactorMock.didSelectProduct).count).to(equal(1))
    }
    
    func test_상품목록의끝에도달했을때_다음페이지상품목록을요청한다() {
        // [given]
        Stubber.register(interactorMock.fetchNextProducts) { _ in }
        // [when]
        presenter.didScrollToEnd()
        // [then]
        expect(Stubber.executions(self.interactorMock.fetchNextProducts).count).to(equal(1))
    }
    
    func test_더보기재시도가선택됐을때_다음페이지상품목록을요청한다() {
        // [given]
        Stubber.register(interactorMock.didRetryOnSeeingMore) { _ in }
        // [when]
        presenter.didRetryOnSeeingMore()
        // [then]
        expect(Stubber.executions(self.interactorMock.didRetryOnSeeingMore).count).to(equal(1))
    }
    
    func test_검색이선택됐을때_입력된검색어에해당하는상품목록을요청한다() {
        // [given]
        Stubber.register(interactorMock.didSelectKeywordSearch) { _ in }
        let testKeyword = "keyword"
        // [when]
        presenter.didSelectKeywordSearch(testKeyword)
        // [then]
        let f = Stubber.executions(self.interactorMock.didSelectKeywordSearch)
        expect(f[safe: 0]?.arguments).to(equal(testKeyword))
    }
    
    func test_interactor가요청했을때_로딩인디케이터를보여준다() {
        // [given]
        Stubber.register(viewMock.showLoadingIndicator) { _ in }
        // [when]
        presenter.showLoadingIndicator()
        // [then]
        expect(Stubber.executions(self.viewMock.showLoadingIndicator).count).to(equal(1))
    }
    
    func test_interactor가요청했을때_로딩인디케이터를숨긴다() {
        // [given]
        Stubber.register(viewMock.hideLoadingIndicator) { _ in }
        // [when]
        presenter.hideLoadingIndicator()
        // [then]
        expect(Stubber.executions(self.viewMock.hideLoadingIndicator).count).to(equal(1))
    }
    
    
    func test_검색어입력을끝냈을때_현재검색결과의검색어를보여준다() {
        // [given]
        Stubber.register(interactorMock.didEndEditingSearchKeyword) { _ in }
        // [when]
        presenter.didEndEditingSearchKeyword()
        // [then]
        expect(Stubber.executions(self.interactorMock.didEndEditingSearchKeyword).count).to(equal(1))
    }
    
    func test_interactor요청했을때_전달받은검색어를보여준다() {
        // [given]
        Stubber.register(viewMock.showSearchKeyword) { _ in }
        let keyword = "test"
        // [when]
        presenter.showSearchKeyword(keyword)
        // [then]
        let f = Stubber.executions(self.viewMock.showSearchKeyword)
        expect(f[safe: 0]?.arguments).to(equal(keyword))
    }

    
    func test_interactor가요청했을때_맨앞으로스크롤한다() {
        // [given]
        Stubber.register(viewMock.scrollToTop) { _ in }
        // [when]
        presenter.scrollToTop()
        // [then]
        expect(Stubber.executions(self.viewMock.scrollToTop).count).to(equal(1))
    }
}

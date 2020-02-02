//
//  ProductIndexInteractor.swift
//  ShoppingmallTests
//
//  Created by mine on 2019/12/03.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import XCTest
@testable import BookFinder
import Stubber
import Nimble

class ProductIndexInteractorTests: XCTestCase {

    var interactor: ProductIndexInputBoundary!
    var repositoryStub = ProductSummaryRepositoryStub()
    var outputBoundaryMock: ProductIndexOutputBoundaryMock!

    override func setUp() {
        outputBoundaryMock = ProductIndexOutputBoundaryMock()
        interactor = ProductIndexInteractor(outputBoundary: outputBoundaryMock, repository: repositoryStub)
        outputBoundaryMock.setInteractor(interactor)
    }

    override func tearDown() {}
    
    func test_첫페이지상품목록을요청했을때_성공하면_상품목록을보여준다() {
        // [given]
        Stubber.register(outputBoundaryMock.showLoadingIndicator) { _ in }
        Stubber.register(outputBoundaryMock.loadProducts) { _ in }
        Stubber.register(outputBoundaryMock.scrollToTop) { _ in }
        Stubber.register(outputBoundaryMock.hideLoadingIndicator) { _ in }
        repositoryStub.setTestData([])
        repositoryStub.setSuccess(true)
        // [when]
        interactor.fetchFirstProducts()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.showLoadingIndicator).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.loadProducts).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.scrollToTop).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.hideLoadingIndicator).count).to(equal(1))
    }
    
    func test_첫페이지상품목록을요청했을때_실패하면_에러메시지를보여준다() {
        // [given]
        Stubber.register(outputBoundaryMock.showLoadingIndicator) { _ in }
        Stubber.register(outputBoundaryMock.loadProducts) { _ in }
        Stubber.register(outputBoundaryMock.showSearchKeyword) { _ in }
        Stubber.register(outputBoundaryMock.alertErrorMessage) { _ in }
        Stubber.register(outputBoundaryMock.hideLoadingIndicator) { _ in }
     
        repositoryStub.setSuccess(false)
        // [when]
        interactor.fetchFirstProducts()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.loadProducts).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.showSearchKeyword).count).to(equal(1))
         expect(Stubber.executions(self.outputBoundaryMock.hideLoadingIndicator).count).to(equal(1))
        
        let f = Stubber.executions(self.outputBoundaryMock.alertErrorMessage)
        expect(f[safe: 0]?.arguments).to(equal(repositoryStub.testErrorMessage))
        expect(Stubber.executions(self.outputBoundaryMock.hideLoadingIndicator).count).to(equal(1))
    }

    func test_특정상품을선택했을때_상품상세화면으로이동한다() {
        // [given]
        Stubber.register(outputBoundaryMock.showProductDetail) { _ in }
        let testList = [Book(id: "a", thumbnailImage: URL(string: "https://test.com"))]
        let testIndex = testList.count - 1
        repositoryStub.setSuccess(true)
        repositoryStub.setTestData(testList)
        interactor.fetchFirstProducts()
        // [when]
        interactor.didSelectProduct(index: testIndex)
        // [then]
        let f = Stubber.executions(outputBoundaryMock.showProductDetail)
        expect(f[safe: 0]?.arguments.0).to(equal(testList[testIndex].id))
        expect(f[safe: 0]?.arguments.1).to(equal(testList[testIndex].thumbnailImage))
    }

    func test_다음페이지상품목록을요청했을때_성공하면_기존목록에추가하여보여준다() {
        // [given]
        Stubber.register(outputBoundaryMock.deactivateRetryOnSeeingMore) { _ in }
        Stubber.register(outputBoundaryMock.loadProducts) { _ in }
        let testObj1 = Book(id: "a", thumbnailImage: URL(string: "https://test1.com"))
        repositoryStub.setSuccess(true)
        repositoryStub.setTestData([testObj1])
        interactor.fetchFirstProducts()
        let testObj2 = Book(id: "b", thumbnailImage: URL(string: "https://test2.com"))
        repositoryStub.setSuccess(true)
        repositoryStub.setTestData([testObj2])
        // [when]
        interactor.fetchNextProducts()
        // [then]
        let f = Stubber.executions(self.outputBoundaryMock.loadProducts)
        let secondCall = 1
        let products = f[safe: secondCall]?.arguments ?? []
        expect(products[safe: 0]?.id).to(equal(testObj1.id))
        expect(products[safe: 1]?.id).to(equal(testObj2.id))
    }
    
    func test_다음페이지상품목록을요청했을때_실패하면_재시도가능하게만든다() {
        // [given]
        Stubber.register(outputBoundaryMock.deactivateRetryOnSeeingMore) { _ in }
        Stubber.register(outputBoundaryMock.activateRetryOnSeeingMore) { _ in }
        Stubber.register(outputBoundaryMock.alertErrorMessage) { _ in }
        repositoryStub.setSuccess(false)
        // [when]
        interactor.fetchNextProducts()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.activateRetryOnSeeingMore).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.alertErrorMessage).count).to(equal(1))
    }

    func test_더보기재시도가선택됐을때_다음페이지상품목록을요청한다() {
        // [given]
        let repositoryMock = ProductSummaryRepositoryMock(networking: NetworkingSeriveMock())
        interactor = ProductIndexInteractor(outputBoundary: outputBoundaryMock, repository: repositoryMock)
        Stubber.register(repositoryMock.fetchBooks) { _ in }
        // [when]
        interactor.didRetryOnSeeingMore()
        // [then]
        expect(Stubber.executions(repositoryMock.fetchBooks).count).to(equal(1))
    }

    func test_검색어에해당하는상품목록을요청했을때_성공하면_상품목록을보여준다() {
        // [given]
        Stubber.register(outputBoundaryMock.showLoadingIndicator) { _ in }
        Stubber.register(outputBoundaryMock.loadProducts) { _ in }
        Stubber.register(outputBoundaryMock.scrollToTop) { _ in }
        Stubber.register(outputBoundaryMock.hideLoadingIndicator) { _ in }
        
        repositoryStub.setTestData([])
        repositoryStub.setSuccess(true)
        // [when]
        interactor.didSelectKeywordSearch("dummyKeyword")
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.showLoadingIndicator).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.loadProducts).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.scrollToTop).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.hideLoadingIndicator).count).to(equal(1))
    }
    
    func test_검색요청을하지않은채입력을끝냈을때_현재검색결과의검색어를보여준다() {
        // [given]
        Stubber.register(outputBoundaryMock.loadProducts) { _ in }
        Stubber.register(outputBoundaryMock.showLoadingIndicator) { _ in }
        Stubber.register(outputBoundaryMock.hideLoadingIndicator) { _ in }
        Stubber.register(outputBoundaryMock.showSearchKeyword) { _ in }
        repositoryStub.setSuccess(true)
        repositoryStub.setTestData([])
        let prevKeyword = "prev"
        interactor.didSelectKeywordSearch(prevKeyword)
        // [when]
        interactor.didEndEditingSearchKeyword()
        // [then]
        let f = Stubber.executions(self.outputBoundaryMock.showSearchKeyword)
        expect(f[safe: 0]?.arguments).to(equal(prevKeyword))
    }
}

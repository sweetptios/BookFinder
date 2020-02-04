//
//  BookIndexInteractor.swift
//  ShoppingmallTests
//
//  Created by mine on 2019/12/03.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import XCTest
@testable import BookFinder
import Stubber
import Nimble

class BookIndexInteractorTests: XCTestCase {

    var interactor: BookIndexInputBoundary!
    var repositoryStub = BookSummaryRepositoryStub()
    var outputBoundaryMock: BookIndexOutputBoundaryMock!

    override func setUp() {
        outputBoundaryMock = BookIndexOutputBoundaryMock()
        interactor = BookIndexInteractor(outputBoundary: outputBoundaryMock, repository: repositoryStub)
    }

    override func tearDown() {}
    
    func test_첫페이지책목록을요청했을때_성공하면_책목록을보여준다() {
        // [given]
        Stubber.register(outputBoundaryMock.showLoadingIndicator) { _ in }
        Stubber.register(outputBoundaryMock.showBooks) { _ in }
        Stubber.register(outputBoundaryMock.scrollToTop) { _ in }
        Stubber.register(outputBoundaryMock.hideLoadingIndicator) { _ in }
        Stubber.register(outputBoundaryMock.showTotalCount) { _ in }
        repositoryStub.setTestData(([],0))
        repositoryStub.setSuccess(true)
        // [when]
        interactor.viewDidLoad()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.showLoadingIndicator).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.showBooks).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.scrollToTop).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.hideLoadingIndicator).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.showTotalCount).count).to(equal(1))
    }
    
    func test_첫페이지책목록을요청했을때_실패하면_에러메시지를보여준다() {
        // [given]
        Stubber.register(outputBoundaryMock.showLoadingIndicator) { _ in }
        Stubber.register(outputBoundaryMock.showBooks) { _ in }
        Stubber.register(outputBoundaryMock.showSearchKeyword) { _ in }
        Stubber.register(outputBoundaryMock.alertErrorMessage) { _ in }
        Stubber.register(outputBoundaryMock.hideLoadingIndicator) { _ in }
        Stubber.register(outputBoundaryMock.showTotalCount) { _ in }
        repositoryStub.setSuccess(false)
        let totalCount = 0
        // [when]
        interactor.viewDidLoad()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.showBooks).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.showSearchKeyword).count).to(equal(2))
        expect(Stubber.executions(self.outputBoundaryMock.hideLoadingIndicator).count).to(equal(1))
        
        let f1 = Stubber.executions(self.outputBoundaryMock.alertErrorMessage)
        expect(f1[safe: 0]?.arguments).to(equal(repositoryStub.testErrorMessage))
        expect(Stubber.executions(self.outputBoundaryMock.hideLoadingIndicator).count).to(equal(1))
        let f2 = Stubber.executions(self.outputBoundaryMock.showTotalCount)
        expect(f2[safe: 0]?.arguments).to(equal(totalCount))
    }

    func test_특정책을선택했을때_책상세화면으로이동한다() {
        // [given]
        Stubber.register(outputBoundaryMock.showBookDetail) { _ in }
        let testList = [Book(id: "a", detailInfo: URL(string: "https://test.com"))]
        let testResult = (testList, 0)
        let testIndex = testList.count - 1
        repositoryStub.setSuccess(true)
        repositoryStub.setTestData(testResult)
        interactor.viewDidLoad()
        // [when]
        interactor.didSelectBook(index: testIndex)
        // [then]
        let f = Stubber.executions(outputBoundaryMock.showBookDetail)
        expect(f[safe: 0]?.arguments.0).to(equal(testList[testIndex].id))
        expect(f[safe: 0]?.arguments.1).to(equal(testList[testIndex].detailInfo))
    }

    func test_다음페이지책목록을요청했을때_성공하면_기존목록에추가하여보여준다() {
        // [given]
        Stubber.register(outputBoundaryMock.deactivateRetryOnSeeingMore) { _ in }
        Stubber.register(outputBoundaryMock.showBooks) { _ in }
        let testObj1 = Book(id: "a", thumbnailImage: URL(string: "https://test1.com"))
        let testResult1 = ([testObj1], 10)
        repositoryStub.setSuccess(true)
        repositoryStub.setTestData(testResult1)
        interactor.viewDidLoad()
        let testObj2 = Book(id: "b", thumbnailImage: URL(string: "https://test2.com"))
        let testResult2 = ([testObj2], 10)
        repositoryStub.setSuccess(true)
        repositoryStub.setTestData(testResult2)
        // [when]
        interactor.fetchNextBooks()
        // [then]
        let f = Stubber.executions(self.outputBoundaryMock.showBooks)
        let secondCall = 1
        let products = f[safe: secondCall]?.arguments ?? []
        expect(products[safe: 0]?.id).to(equal(testObj1.id))
        expect(products[safe: 1]?.id).to(equal(testObj2.id))
    }
    
    func test_다음페이지책목록을요청했을때_실패하면_재시도가능하게만든다() {
        // [given]
        Stubber.register(outputBoundaryMock.deactivateRetryOnSeeingMore) { _ in }
        Stubber.register(outputBoundaryMock.activateRetryOnSeeingMore) { _ in }
        Stubber.register(outputBoundaryMock.alertErrorMessage) { _ in }
        repositoryStub.setSuccess(false)
        // [when]
        interactor.fetchNextBooks()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.activateRetryOnSeeingMore).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.alertErrorMessage).count).to(equal(1))
    }

    func test_더보기재시도가선택됐을때_다음페이지책목록을요청한다() {
        // [given]
        let repositoryMock = BookSummaryRepositoryMock(networking: NetworkingSeriveMock())
        interactor = BookIndexInteractor(outputBoundary: outputBoundaryMock, repository: repositoryMock)
        Stubber.register(repositoryMock.fetchBooks) { _ in }
        // [when]
        interactor.didRetryOnSeeingMore()
        // [then]
        expect(Stubber.executions(repositoryMock.fetchBooks).count).to(equal(1))
    }

    func test_검색어에해당하는책목록을요청했을때_성공하면_책목록을보여준다() {
        // [given]
        Stubber.register(outputBoundaryMock.showLoadingIndicator) { _ in }
        Stubber.register(outputBoundaryMock.showBooks) { _ in }
        Stubber.register(outputBoundaryMock.scrollToTop) { _ in }
        Stubber.register(outputBoundaryMock.hideLoadingIndicator) { _ in }
        Stubber.register(outputBoundaryMock.showTotalCount) { _ in }
        
        repositoryStub.setTestData(([],0))
        repositoryStub.setSuccess(true)
        // [when]
        interactor.didSelectKeywordSearch("dummyKeyword")
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.showLoadingIndicator).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.showBooks).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.scrollToTop).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.hideLoadingIndicator).count).to(equal(1))
        expect(Stubber.executions(self.outputBoundaryMock.showTotalCount).count).to(equal(1))
    }
    
    func test_검색요청을하지않은채입력을끝냈을때_현재검색결과의검색어를보여준다() {
        // [given]
        Stubber.register(outputBoundaryMock.showBooks) { _ in }
        Stubber.register(outputBoundaryMock.showLoadingIndicator) { _ in }
        Stubber.register(outputBoundaryMock.hideLoadingIndicator) { _ in }
        Stubber.register(outputBoundaryMock.showSearchKeyword) { _ in }
        repositoryStub.setSuccess(true)
        repositoryStub.setTestData(([],0))
        let prevKeyword = "prev"
        interactor.didSelectKeywordSearch(prevKeyword)
        // [when]
        interactor.didEndEditingSearchKeyword()
        // [then]
        let f = Stubber.executions(self.outputBoundaryMock.showSearchKeyword)
        expect(f[safe: 0]?.arguments).to(equal(prevKeyword))
    }
}

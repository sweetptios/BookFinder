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
        Stubber.register(outputBoundaryMock.goToWebPage) { _ in }
        let dummyItemId = "a"
        let url = URL(string: "https://test.com")
        interactor = BookDetailInteractor(outputBoundary: outputBoundaryMock, itemId: dummyItemId, detailInfoUrl: url)
        // [when]
        interactor.viewDidLoad()
        // [then]
        let f = Stubber.executions(self.outputBoundaryMock.goToWebPage)
        expect(f[0].arguments).to(equal(url))
    }
    
    func test_뒤로가기를선택했을때_이전페이지를보여준다() {
        // [given]
        Stubber.register(outputBoundaryMock.goBackToPrevWebPage) { _ in }
        // [when]
        interactor.didSelectBack()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.goBackToPrevWebPage).count).to(equal(1))
    }
    
    func test_앞으로가기를선택했을때_다음페이지를보여준다() {
        // [given]
        Stubber.register(outputBoundaryMock.goForwardToNextWebPage) { _ in }
        // [when]
        interactor.didSelectForward()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.goForwardToNextWebPage).count).to(equal(1))
    }
    
    func test_리로드를선택했을때_현재페이지를리로드해준다() {
        // [given]
        Stubber.register(outputBoundaryMock.reloadWebPage) { _ in }
        // [when]
        interactor.didSelectReload()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.reloadWebPage).count).to(equal(1))
    }
    
    func test_홈을선택했을때_처음진입한페이지로이동한다() {
        // [given]
        Stubber.register(outputBoundaryMock.goToWebPage) { _ in }
        let dummyItemId = "b"
        let url = URL(string: "https://test.com")
        interactor = BookDetailInteractor(outputBoundary: outputBoundaryMock, itemId: dummyItemId, detailInfoUrl: url)
        // [when]
        interactor.didSelectHome()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.goToWebPage).count).to(equal(1))
    }
    
    func test_닫기를선택했을때_이전화면으로돌아간다() {
        // [given]
        Stubber.register(outputBoundaryMock.exit) { _ in }
        // [when]
        interactor.didSelectClose()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.exit).count).to(equal(1))
    }
}

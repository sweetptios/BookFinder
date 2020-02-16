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
    var otherAppServiceMock: OtherAppServiceMock!

    override func setUp() {
        outputBoundaryMock = BookDetailOutputBoundaryMock()
        otherAppServiceMock = OtherAppServiceMock()
        let dummyItemId = "a"
        let dummyDetailInfoUrl = URL(string: "")
        interactor = BookDetailInteractor(outputBoundary: outputBoundaryMock, itemId: dummyItemId, detailInfoUrl: dummyDetailInfoUrl, otherAppService: otherAppServiceMock)
    }

    override func tearDown() {}
    
    func test_뷰가준비가되었을때_책정보웹페이지를보여준다() {
        // [given]
        registerMethodsInMock()
        let dummyItemId = "a"
        let dummyOtherAppService = OtherAppServiceMock()
        let url = URL(string: "https://test.com")
        interactor = BookDetailInteractor(outputBoundary: outputBoundaryMock, itemId: dummyItemId, detailInfoUrl: url, otherAppService: dummyOtherAppService)
        // [when]
        interactor.viewIsReady()
        // [then]
        let f = Stubber.executions(self.outputBoundaryMock.goToWebPage)
        expect(f[0].arguments).to(equal(url))
    }
    
    func test_뒤로가기를선택했을때_이전웹페이지를보여준다() {
        // [given]
        registerMethodsInMock()
        // [when]
        interactor.didSelectBack()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.goBackToPrevWebPage).count).to(equal(1))
    }

    func test_앞으로가기를선택했을때_다음웹페이지를보여준다() {
        // [given]
        registerMethodsInMock()
        // [when]
        interactor.didSelectForward()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.goForwardToNextWebPage).count).to(equal(1))
    }
    
    func test_리로드를선택했을때_현재웹페이지를리로드해준다() {
        // [given]
        registerMethodsInMock()
        // [when]
        interactor.didSelectReload()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.reloadWebPage).count).to(equal(1))
    }
    
    func test_홈을선택했을때_처음진입한페이지로이동한다() {
        // [given]
        registerMethodsInMock()
        let dummyItemId = "b"
        let dummyOtherAppService = OtherAppServiceMock()
        let url = URL(string: "https://test.com")
        interactor = BookDetailInteractor(outputBoundary: outputBoundaryMock, itemId: dummyItemId, detailInfoUrl: url, otherAppService: dummyOtherAppService)
        // [when]
        interactor.didSelectHome()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.goToWebPage).count).to(equal(1))
    }
    
    func test_사파리를선택했을때_현재보여지는웹페이지를사파리를열어보여준다() {
        // [given]
        registerMethodsInMock()
        let url = URL(string: "https://test.com")!
        interactor.webpageWasChanged(url)
        // [when]
        interactor.didSelectSafari()
        // [then]
        let f = Stubber.executions(self.otherAppServiceMock.viewInSafari)
        expect(f[0].arguments).to(equal(url))
    }
    
    func test_공유선택했을때_웹페이지공유화면으로이동한다() {
        // [given]
        registerMethodsInMock()
        let url = URL(string: "https://test.com")!
        interactor.webpageWasChanged(url)
        // [when]
        interactor.didSelectShare()
        // [then]
        let f = Stubber.executions(self.outputBoundaryMock.showShareActivity)
        expect(f[0].arguments).to(equal(url))
    }
    
    
    func test_닫기를선택했을때_이전화면으로돌아간다() {
        // [given]
        registerMethodsInMock()
        // [when]
        interactor.didSelectClose()
        // [then]
        expect(Stubber.executions(self.outputBoundaryMock.exit).count).to(equal(1))
    }
    
    private func registerMethodsInMock() {
        Stubber.register(outputBoundaryMock.goToWebPage) { _ in }
        Stubber.register(outputBoundaryMock.goBackToPrevWebPage) { _ in }
        Stubber.register(outputBoundaryMock.goForwardToNextWebPage) { _ in }
        Stubber.register(outputBoundaryMock.reloadWebPage) { _ in }
        Stubber.register(outputBoundaryMock.exit) { _ in }
        Stubber.register(otherAppServiceMock.viewInSafari) { _ in }
        Stubber.register(outputBoundaryMock.showShareActivity) { _ in }
    }
}

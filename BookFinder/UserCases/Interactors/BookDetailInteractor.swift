//
//  BookDetailInteractor.swift
//  BookFinder
//
//  Created by GOOK HEE JUNG on 2020/02/03.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import UIKit
import Foundation

protocol BookDetailInputBoundary: class {
    init(outputBoundary: BookDetailOutputBoundary, itemId: String, detailInfoUrl: URL?, otherAppService: OtherAppServiceAvailable)
    func viewIsReady()
    func didSelectBack()
    func didSelectForward()
    func didSelectReload()
    func didSelectHome()
    func didSelectSafari()
    func didSelectClose()
    func webpageWasChanged(_ url: URL)
    func didSelectShare()
}

protocol BookDetailOutputBoundary: class {
    func goToWebPage(_ url: URL)
    func goBackToPrevWebPage()
    func goForwardToNextWebPage()
    func reloadWebPage()
    func showShareActivity(with url: URL)
    func exit()
}

class BookDetailInteractor {
    
    private let outputBoundary: BookDetailOutputBoundary!
    private let otherAppService: OtherAppServiceAvailable!
    private let itemId: String
    private let detailInfoUrl: URL?
    private var state: State
    
    struct State {
        var nowUrl: URL?
    }
    
    required init(outputBoundary: BookDetailOutputBoundary, itemId: String, detailInfoUrl: URL?, otherAppService: OtherAppServiceAvailable) {
        self.outputBoundary = outputBoundary
        self.itemId = itemId
        self.detailInfoUrl = detailInfoUrl
        self.otherAppService = otherAppService
        state = State(nowUrl: self.detailInfoUrl)
    }
}

extension BookDetailInteractor: BookDetailInputBoundary {

    func viewIsReady() {
        if let url = detailInfoUrl {
            outputBoundary.goToWebPage(url)
        }
    }
    
    func didSelectBack() {
        outputBoundary.goBackToPrevWebPage()
    }
    
    func didSelectForward() {
        outputBoundary.goForwardToNextWebPage()
    }
    
    func didSelectReload() {
        outputBoundary.reloadWebPage()
    }
    
    func didSelectHome() {
        if let url = detailInfoUrl {
            outputBoundary.goToWebPage(url)
        }
    }
    
    func didSelectShare() {
        if let nowUrl = state.nowUrl {
            outputBoundary.showShareActivity(with: nowUrl)
        }
    }
    
    func didSelectSafari() {
        if let nowUrl = state.nowUrl {
            otherAppService.viewInSafari(with: nowUrl)
        }
    }
    
    func didSelectClose() {
        outputBoundary.exit()
    }
    
    func webpageWasChanged(_ url: URL) {
        state.nowUrl = url
    }
}

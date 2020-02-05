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
    init(outputBoundary: BookDetailOutputBoundary, itemId: String, detailInfoUrl: URL?)
    func viewDidLoad()
    func didSelectBack()
    func didSelectForward()
    func didSelectReload()
    func didSelectHome()
    func didSelectClose()
}

protocol BookDetailOutputBoundary: class {
    func goToWebPage(_ url: URL)
    func goBackToPrevWebPage()
    func goForwardToNextWebPage()
    func reloadWebPage()
    func exit()
}

class BookDetailInteractor {
    
    private let outputBoundary: BookDetailOutputBoundary!
    private let itemId: String
    private let detailInfoUrl: URL?
    
    required init(outputBoundary: BookDetailOutputBoundary, itemId: String, detailInfoUrl: URL?) {
        self.outputBoundary = outputBoundary
        self.itemId = itemId
        self.detailInfoUrl = detailInfoUrl
    }
}

extension BookDetailInteractor: BookDetailInputBoundary {

    func viewDidLoad() {
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
    
    func didSelectClose() {
        outputBoundary.exit()
    }
}

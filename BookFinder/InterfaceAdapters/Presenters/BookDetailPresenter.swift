//
//  BookDetailPresenter.swift
//  BookFinder
//
//  Created by GOOK HEE JUNG on 2020/02/03.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import Foundation

//MARK: - BookDetailView

protocol BookDetailViewControllable: class {
    func loadWebPage(_ url: URL)
    func goBackToPrevWebPage()
    func goForwardToNextWebPage()
    func reloadWebPage()
    func showShareActivity(with url: URL)
    func exit()
}

//MARK: - BookDetailPresenter

class BookDetailPresenter {
    
    private weak var view: BookDetailViewControllable!
}

extension BookDetailPresenter {
    
    func setView(_ view: BookDetailViewControllable) {
        self.view = view
    }
}

extension BookDetailPresenter: BookDetailOutputBoundary {
    
    func goToWebPage(_ url: URL) {
        view.loadWebPage(url)
    }
    
    func goBackToPrevWebPage() {
        view.goBackToPrevWebPage()
    }
    
    func goForwardToNextWebPage() {
        view.goForwardToNextWebPage()
    }
    
    func reloadWebPage() {
        view.reloadWebPage()
    }
    
    func showShareActivity(with url: URL) {
        view.showShareActivity(with: url)
    }
    
    func exit() {
        view.exit()
    }
}

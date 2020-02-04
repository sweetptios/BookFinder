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
    func showBookDetail(_ url: URL?)
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
    
    func showBookDetail(_ url: URL?) {
        view.showBookDetail(url)
    }
}

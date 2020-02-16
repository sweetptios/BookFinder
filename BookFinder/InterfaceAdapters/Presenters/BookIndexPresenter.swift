//
//  BookIndexPresenter.swift
//  cosmetics
//
//  Created by mine on 2020/02/05.
//  Copyright © 2020 sweetptdev. All rights reserved.
//

import Foundation

//MARK: - BookIndexViewControllable
protocol BookIndexViewControllable: class {
    func showBooks(_ products: [BookIndexItemViewData])
    func showBookDetail(id: String, detailInfoUrl: URL?)
    func showSearchKeyword(_ keyword: String)
    func showTotalCount(_ count: String)
    func showErrorMessage(title: String, message: String, buttonTitle: String)
    func deactivateRetryOnSeeingMore()
    func activateRetryOnSeeingMore()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func moveToTop()
}

//MARK: - BookIndexPresenter

class BookIndexPresenter {
    private weak var view: BookIndexViewControllable?
}

extension BookIndexPresenter {
    
    func setView(_ view: BookIndexViewControllable) {
        self.view = view
    }
}

extension BookIndexPresenter: BookIndexOutputBoundary {
    
    func showBooks(_ productList: [BookSummary]) {
        
        view?.showBooks(productList.map{
            let displayedDate = $0.publishedDate?.string(format: "yyyy-MM-dd") ?? ""
            var displayedAuthors = $0.authors.first ?? ""
            if $0.authors.count >= 2 {
                displayedAuthors += "외 \($0.authors.count)명"
            }
            return BookIndexItemViewData(id: $0.id, thumbnailUrl: $0.thumbnailImage, title: $0.title, author: displayedAuthors, publishedDate: displayedDate)
        })
    }
    
    func showBookDetail(id: String, detailInfoUrl: URL?) {
        view?.showBookDetail(id: id, detailInfoUrl: detailInfoUrl)
    }
    
    func showTotalCount(_ count: Int) {
        view?.showTotalCount("Result: (\(count))")
    }
    
    func showErrorMessage(_ message: String) {
        view?.showErrorMessage(title: "오류", message: message, buttonTitle: "확인")
    }
    
    func activateRetryOnSeeingMore() {
        view?.activateRetryOnSeeingMore()
    }
    
    func deactivateRetryOnSeeingMore() {
        view?.deactivateRetryOnSeeingMore()
    }
    
    func showLoadingIndicator() {
        view?.showLoadingIndicator()
    }
    
    func hideLoadingIndicator() {
        view?.hideLoadingIndicator()
    }
    
    func showSearchKeyword(_ keyword: String) {
        view?.showSearchKeyword(keyword)
    }
    
    func moveToTop() {
        view?.moveToTop()
    }
    
}

//MARK: - Data for View

struct BookIndexItemViewData {
    private(set) var id: String
    private(set) var thumbnailUrl: URL?
    private(set) var title: String
    private(set) var author: String
    private(set) var publishedDate: String
}


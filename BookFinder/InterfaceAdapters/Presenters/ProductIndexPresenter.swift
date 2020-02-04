//
//  ProductIndexPresenter.swift
//  cosmetics
//
//  Created by mine on 2020/01/15.
//  Copyright © 2020 sweetptdev. All rights reserved.
//

import Foundation

protocol ProductIndexViewControllable: class {
    func showProducts(_ products: [ProductIndexCollectionItemViewData])
    func showProductDetail(id: String, detailInfoUrl: URL?)
    func showSearchKeyword(_ keyword: String)
    func showTotalCount(_ count: String)
    func alertErrorMessage(title: String, message: String, buttonTitle: String)
    func deactivateRetryOnSeeingMore()
    func activateRetryOnSeeingMore()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func scrollToTop()
}

class ProductIndexPresenter {
    private weak var view: ProductIndexViewControllable?
}

extension ProductIndexPresenter {
    
    func setView(_ view: ProductIndexViewControllable) {
        self.view = view
    }
}

extension ProductIndexPresenter: ProductIndexOutputBoundary {
    
    func showProducts(_ productList: [ProductSummary]) {
        #warning("TODO- date 리팩토링")
        #warning("TODO- author 리팩토링")
        view?.showProducts(productList.map{
            let displayedDate = $0.publishedDate?.string(format: "yyyy-MM-dd") ?? ""
            var displayedAuthors = $0.authors.first ?? ""
            if $0.authors.count >= 2 {
                displayedAuthors += "외 \($0.authors.count)명"
            }
            return ProductIndexCollectionItemViewData(id: $0.id, thumbnailUrl: $0.thumbnailImage, title: $0.title, author: displayedAuthors, publishedDate: displayedDate)
        })
    }
    
    func showProductDetail(id: String, detailInfoUrl: URL?) {
        view?.showProductDetail(id: id, detailInfoUrl: detailInfoUrl)
    }
    
    func showTotalCount(_ count: Int) {
        view?.showTotalCount("Result: (\(count))")
    }
    
    func alertErrorMessage(_ message: String) {
        view?.alertErrorMessage(title: "오류", message: message, buttonTitle: "확인")
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
    
    func scrollToTop() {
        view?.scrollToTop()
    }
    
}


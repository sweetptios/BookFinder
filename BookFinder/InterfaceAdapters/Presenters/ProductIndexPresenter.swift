//
//  ProductIndexPresenter.swift
//  cosmetics
//
//  Created by mine on 2020/01/15.
//  Copyright © 2020 sweetptdev. All rights reserved.
//

import Foundation

protocol IProductIndexView: class {
    func setPresenter(_ obj: IProductIndexPresenter)
    func showProducts(_ products: [ProductIndexCollectionItemViewData])
    func showProductDetail(id: String, thumbnailImageUrl: URL?)
    func showSearchKeyword(_ keyword: String)
    func alertErrorMessage(title: String, message: String, buttonTitle: String)
    func deactivateRetryOnSeeingMore()
    func activateRetryOnSeeingMore()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func scrollToTop()
}

protocol IProductIndexPresenter: class {
    func viewDidLoad()
    func didSelectProduct(index: Int)
    func didScrollToEnd()
    func didRetryOnSeeingMore()
    func didSelectKeywordSearch(_ keyword: String)
    func didEndEditingSearchKeyword()
}

class ProductIndexPresenter {
    
    private var interactor: ProductIndexInputBoundary?
    private weak var view: IProductIndexView?
    
    init(view: IProductIndexView) {
        self.view = view
    }
}

extension ProductIndexPresenter: IProductIndexPresenter {

    func viewDidLoad() {
        interactor?.fetchFirstProducts()
    }
    
    func didSelectProduct(index: Int) {
        interactor?.didSelectProduct(index: index)
    }
    
    func didScrollToEnd() {
        interactor?.fetchNextProducts()
    }
    
    func didRetryOnSeeingMore() {
        interactor?.didRetryOnSeeingMore()
    }
    
    func didSelectKeywordSearch(_ keyword: String) {
        interactor?.didSelectKeywordSearch(keyword)
    }
    
    func didEndEditingSearchKeyword() {
        interactor?.didEndEditingSearchKeyword()
    }
}

extension ProductIndexPresenter: ProductIndexOutputBoundary {
    
    func setInteractor(_ obj: ProductIndexInputBoundary) {
        interactor = obj
    }
    
    func loadProducts(_ productList: [ProductSummary]) {
        view?.showProducts(productList.map{ ProductIndexCollectionItemViewData(id: $0.id, thumbnailUrl: $0.thumbnailImage, title: $0.title, author: $0.author) })
    }
    
    func showProductDetail(id: String, thumbnailImageUrl: URL?) {
        view?.showProductDetail(id: id, thumbnailImageUrl: thumbnailImageUrl)
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


//
//  ProductIndexMock.swift
//  ShoppingmallTests
//
//  Created by mine on 2019/12/02.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import Foundation
import Stubber
@testable import BookFinder

final class ProductIndexInteractorMock: ProductIndexInputBoundary {

    init(outputBoundary: ProductIndexOutputBoundary, repository: IBookSummaryRepository) {
    }
    
    func didRetryOnSeeingMore() {
        Stubber.invoke(didRetryOnSeeingMore, args: Void())
    }
    
    func fetchNextProducts() {
        Stubber.invoke(fetchNextProducts, args: ())
    }
    
    func fetchCurrentFilterItem() {
        Stubber.invoke(fetchCurrentFilterItem, args: ())
    }
    
    func didSelectProduct(index: Int) {
        Stubber.invoke(didSelectProduct, args: index)
    }
    
    func fetchFirstProducts() {
        Stubber.invoke(fetchFirstProducts, args: ())
    }
    
    func didSelectKeywordSearch(_ keyword: String) {
        Stubber.invoke(didSelectKeywordSearch, args: keyword)
    }
    
    func didSelectSkinType(_ index: Int) {
        Stubber.invoke(didSelectSkinType, args: index)
    }
    
    func fetchFilterItems() {
        Stubber.invoke(fetchFilterItems, args: ())
    }
    
    func didEndEditingSearchKeyword() {
        Stubber.invoke(didEndEditingSearchKeyword, args: ())
    }
}

final class ProductIndexOutputBoundaryMock: ProductIndexOutputBoundary {
    
    func setInteractor(_ obj: ProductIndexInputBoundary) {}
    
    func loadProducts(_ productList: [ProductSummary]) {
        Stubber.invoke(loadProducts, args: productList)
    }
    
    func showProductDetail(id: String, thumbnailImageUrl: URL?) {
        Stubber.invoke(showProductDetail, args: (id, thumbnailImageUrl))
    }
    
    func alertErrorMessage(_ message: String) {
        Stubber.invoke(alertErrorMessage, args: message)
    }
    
    func activateRetryOnSeeingMore() {
        Stubber.invoke(activateRetryOnSeeingMore, args: ())
    }
    
    func deactivateRetryOnSeeingMore() {
        Stubber.invoke(deactivateRetryOnSeeingMore, args: ())
    }
    
    func showLoadingIndicator() {
        Stubber.invoke(showLoadingIndicator, args: ())
    }
    
    func hideLoadingIndicator() {
        Stubber.invoke(hideLoadingIndicator, args: ())
    }
    
    func showSearchKeyword(_ keyword: String) {
        Stubber.invoke(showSearchKeyword, args: keyword)
    }
    
    func scrollToTop() {
        Stubber.invoke(scrollToTop, args: ())
    }
}

final class ProductIndexViewMock: IProductIndexView {

    func setPresenter(_ obj: IProductIndexPresenter) {}
    
    func showProducts(_ products: [ProductIndexCollectionItemViewData]) {
        Stubber.invoke(showProducts, args: products)
    }
    
    func alertErrorMessage(title: String, message: String, buttonTitle: String) {
        Stubber.invoke(alertErrorMessage, args: (title, message, buttonTitle))
    }
    
    func showProductDetail(id: String, thumbnailImageUrl: URL?) {
        Stubber.invoke(showProductDetail, args: (id, thumbnailImageUrl))
    }
    
    func activateRetryOnSeeingMore() {
        Stubber.invoke(activateRetryOnSeeingMore, args: ())
    }
    
    func deactivateRetryOnSeeingMore() {
        Stubber.invoke(deactivateRetryOnSeeingMore, args: ())
    }
    
    func showCurrentFilterItem(_ name: String) {
        Stubber.invoke(showCurrentFilterItem, args: name)
    }
    
    func showFilterItems(title: String, items: [String]) {
        Stubber.invoke(showFilterItems, args: (title, items))
    }
    
    func showLoadingIndicator() {
        Stubber.invoke(showLoadingIndicator, args: ())
    }
    
    func hideLoadingIndicator() {
        Stubber.invoke(hideLoadingIndicator, args: ())
    }
    
    func showSearchKeyword(_ keyword: String) {
        Stubber.invoke(showSearchKeyword, args: keyword)
    }
    
    func scrollToTop() {
        Stubber.invoke(scrollToTop, args: ())
    }
}

final class ProductSummaryRepositoryMock: IBookSummaryRepository {
    
    func fetchBooks(page: Int, keyword: String, completion: ((Result<[Book], RepositoryError>) -> Void)?) {
        Stubber.invoke(fetchBooks, args: escaping(page, keyword, completion))
    }
    
    init(networking: INetworkingService) {}
}

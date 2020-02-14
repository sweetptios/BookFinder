//
//  BookIndexMock.swift
// BookFinderTests
//
//  Created by mine on 2020/02/03.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import Foundation
import Stubber
@testable import BookFinder

final class BookIndexInteractorMock: BookIndexInputBoundary {

    init(outputBoundary: BookIndexOutputBoundary, repository: IBookSummaryRepository) {}
    
    func didRetryOnSeeingMore() {
        Stubber.invoke(didRetryOnSeeingMore, args: ())
    }
    
    func didSelectSeeingMore() {
        Stubber.invoke(didSelectSeeingMore, args: ())
    }
    
    func fetchCurrentFilterItem() {
        Stubber.invoke(fetchCurrentFilterItem, args: ())
    }
    
    func didSelectBook(index: Int) {
        Stubber.invoke(didSelectBook, args: index)
    }
    
    func viewIsReady(columnCount: Int) {
        Stubber.invoke(viewIsReady, args: columnCount)
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

final class BookIndexOutputBoundaryMock: BookIndexOutputBoundary {
    
    func showBooks(_ productList: [BookSummary]) {
        Stubber.invoke(showBooks, args: productList)
    }
    
    func showBookDetail(id: String, detailInfoUrl: URL?) {
        Stubber.invoke(showBookDetail, args: (id, detailInfoUrl))
    }
    
    func showTotalCount(_ count: Int) {
        Stubber.invoke(showTotalCount, args: count)
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

final class BookIndexViewMock: BookIndexViewControllable {
    
    func showBooks(_ products: [BookIndexItemViewData]) {
        Stubber.invoke(showBooks, args: products)
    }
    
    func alertErrorMessage(title: String, message: String, buttonTitle: String) {
        Stubber.invoke(alertErrorMessage, args: (title, message, buttonTitle))
    }
    
    func showBookDetail(id: String, detailInfoUrl: URL?) {
        Stubber.invoke(showBookDetail, args: (id, detailInfoUrl))
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
    
    func showTotalCount(_ count: String) {
        Stubber.invoke(showTotalCount, args: count)
    }
}

final class BookSummaryRepositoryMock: IBookSummaryRepository {
    
    init(networking: INetworkingService) {}
    
    func fetchBooks(page: Int, keyword: String, maxResultCount: Int, completion: ((Result<(books: [Book], totalCount: Int), RepositoryError>) -> Void)?) {
        Stubber.invoke(fetchBooks, args: escaping(page, keyword, maxResultCount, completion))
    }
}

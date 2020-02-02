//
//  ProductIndexInteractor.swift
//  Shoppingmall
//
//  Created by mine on 2019/12/02.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import Foundation

protocol ProductIndexInputBoundary: class {
    init(outputBoundary: ProductIndexOutputBoundary, repository: IBookSummaryRepository)
    func fetchFirstProducts()
    func fetchNextProducts()
    func didRetryOnSeeingMore()
    func didSelectProduct(index: Int)
    func didSelectKeywordSearch(_ keyword: String)
    func didEndEditingSearchKeyword()
}

protocol ProductIndexOutputBoundary: class {
    func setInteractor(_ obj: ProductIndexInputBoundary)
    func loadProducts(_ productList: [ProductSummary])
    func showProductDetail(id: String, thumbnailImageUrl: URL?)
    func showSearchKeyword(_ keyword: String)
    func alertErrorMessage(_ message: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func activateRetryOnSeeingMore()
    func deactivateRetryOnSeeingMore()
    func scrollToTop()
}

class ProductIndexInteractor {
    
    private weak var outputBoundary: ProductIndexOutputBoundary?
    private var repository: IBookSummaryRepository
    private var state: State
    
    fileprivate struct State {
        var page: Int
        var keyword: String
        var products: [Book]
        
        init() {
            page = 0
            keyword = ""
            products = []
        }
    }
    
    public required init(outputBoundary: ProductIndexOutputBoundary, repository: IBookSummaryRepository) {
        self.outputBoundary = outputBoundary
        self.repository = repository
        self.state = State()
    }
}

extension ProductIndexInteractor: ProductIndexInputBoundary {
    
    func fetchFirstProducts() {
        let newPage = 1
        outputBoundary?.showLoadingIndicator()
        repository.fetchBooks(page: newPage, keyword: state.keyword) {[weak self] (result) in
            guard let self = self else { return }
            switch(result) {
            case let .success(data):
                self.state.page = newPage
                self.state.products = data
                self.outputBoundary?.loadProducts(self.state.products.map{ ProductSummary(from
                :$0) })
                self.outputBoundary?.scrollToTop()
            case let .failure(error):
                self.state = State()
                self.outputBoundary?.loadProducts(self.state.products.map{ ProductSummary(from
                :$0) })
                self.outputBoundary?.showSearchKeyword(self.state.keyword)
                self.outputBoundary?.alertErrorMessage(error.localizedDescription)
            }
            self.outputBoundary?.hideLoadingIndicator()
        }
    }
      
    func didSelectProduct(index: Int) {
        if let product = state.products[safe: index] {
            outputBoundary?.showProductDetail(id: product.id, thumbnailImageUrl: product.thumbnailImage)
        }
    }
    
    func fetchNextProducts() {
        loadProductIndexMore()
    }
    
    func didRetryOnSeeingMore() {
        outputBoundary?.deactivateRetryOnSeeingMore()
        loadProductIndexMore()
    }
    
    private func loadProductIndexMore() {
        repository.fetchBooks(page: state.page + 1, keyword: state.keyword){[weak self](result) in
            guard let self = self else { return }
            switch(result) {
            case let .success(data):
                self.state.page = self.state.page + 1
                self.state.products += data
                self.outputBoundary?.loadProducts(self.state.products.map{ ProductSummary(from: $0) })
            case let .failure(error):
                self.outputBoundary?.activateRetryOnSeeingMore()
                self.outputBoundary?.alertErrorMessage(error.localizedDescription)
            }
        }
    }
    
    func didSelectKeywordSearch(_ keyword: String) {
        state.keyword = keyword
        fetchFirstProducts()
    }
    
    func didEndEditingSearchKeyword() {
        outputBoundary?.showSearchKeyword(state.keyword)
    }
}

struct ProductSummary {
    private(set) var id: String
    private(set) var title: String
    private(set) var author: String
    private(set) var publishedDate: Date?
    private(set) var thumbnailImage: URL?
    
    init(from source: Book) {
        self.id = source.id
        self.title = source.title
        self.author = source.authors.first ?? ""
        self.publishedDate = source.publishedDate
        self.thumbnailImage = source.thumbnailImage
    }
}

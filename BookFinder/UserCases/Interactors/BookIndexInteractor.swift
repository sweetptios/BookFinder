//
//  BookIndexInteractor.swift
//  Shoppingmall
//
//  Created by mine on 2019/12/02.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import Foundation

protocol BookIndexInputBoundary: class {
    init(outputBoundary: BookIndexOutputBoundary, repository: IBookSummaryRepository)
    func viewDidLoad()
    func fetchNextBooks()
    func didRetryOnSeeingMore()
    func didSelectBook(index: Int)
    func didSelectKeywordSearch(_ keyword: String)
    func didEndEditingSearchKeyword()
}

protocol BookIndexOutputBoundary: class {
    func showBooks(_ productList: [BookSummary])
    func showBookDetail(id: String, detailInfoUrl: URL?)
    func showSearchKeyword(_ keyword: String)
    func showTotalCount(_ count: Int)
    func alertErrorMessage(_ message: String)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func activateRetryOnSeeingMore()
    func deactivateRetryOnSeeingMore()
    func scrollToTop()
}

class BookIndexInteractor {
    
    private var outputBoundary: BookIndexOutputBoundary?
    private var repository: IBookSummaryRepository
    private var state: State
    
    fileprivate struct State {
        var page: Int
        var keyword: String
        var products: [Book]
        var totalCount: Int
        
        init() {
            page = 0
            keyword = ""
            products = []
            totalCount = 0
        }
    }
    
    public required init(outputBoundary: BookIndexOutputBoundary, repository: IBookSummaryRepository) {
        self.outputBoundary = outputBoundary
        self.repository = repository
        self.state = State()
    }
}

extension BookIndexInteractor: BookIndexInputBoundary {
      
    func viewDidLoad() {
        state.keyword = "앱 프로그래밍"
        outputBoundary?.showSearchKeyword(state.keyword)
        fetchFirstBooks()
    }
    
    func didSelectBook(index: Int) {
        if let product = state.products[safe: index] {
            outputBoundary?.showBookDetail(id: product.id, detailInfoUrl: product.detailInfo)
        }
    }
    
    func fetchNextBooks() {
        loadBookIndexMore()
    }
    
    func didRetryOnSeeingMore() {
        outputBoundary?.deactivateRetryOnSeeingMore()
        loadBookIndexMore()
    }
    
    
    private func fetchFirstBooks() {
        let newPage = 1
        outputBoundary?.showLoadingIndicator()
        repository.fetchBooks(page: newPage, keyword: state.keyword) {[weak self] (result) in
            guard let self = self else { return }
            switch(result) {
            case let .success(data):
                self.state.page = newPage
                self.state.products = data.books
                self.state.totalCount = data.totalCount
                self.outputBoundary?.scrollToTop()
            case let .failure(error):
                self.state = State()
                self.outputBoundary?.showSearchKeyword(self.state.keyword)
                self.outputBoundary?.alertErrorMessage(error.localizedDescription)
            }
            print("총 current: ", self.state.totalCount)
            self.outputBoundary?.showBooks(self.state.products.map{ BookSummary(from
            :$0) })
            self.outputBoundary?.showTotalCount(self.state.totalCount)
            self.outputBoundary?.hideLoadingIndicator()
        }
    }
    
    private func loadBookIndexMore() {
        repository.fetchBooks(page: state.page + 1, keyword: state.keyword){[weak self](result) in
            guard let self = self else { return }
            switch(result) {
            case let .success(data):
                self.state.page = self.state.page + 1
                self.state.products += data.books
                self.outputBoundary?.showBooks(self.state.products.map{ BookSummary(from: $0) })
                self.state.totalCount = data.totalCount
                self.outputBoundary?.showTotalCount(self.state.totalCount)
            case let .failure(error):
                if error.kind == .emptySearchResult(keyword: self.state.keyword) {
                    #warning("TODO - 인디케이터 감추기")
                } else {
                    self.outputBoundary?.activateRetryOnSeeingMore()
                }
                self.outputBoundary?.alertErrorMessage(error.localizedDescription)
            }
            print("총 current: ", self.state.totalCount)
        }
    }
    
    func didSelectKeywordSearch(_ keyword: String) {
        state.keyword = keyword
        fetchFirstBooks()
    }
    
    func didEndEditingSearchKeyword() {
        outputBoundary?.showSearchKeyword(state.keyword)
    }
}

struct BookSummary {
    private(set) var id: String
    private(set) var title: String
    private(set) var authors: [String]
    private(set) var publishedDate: Date?
    private(set) var thumbnailImage: URL?
    
    init(from source: Book) {
        self.id = source.id
        self.title = source.title
        self.authors = source.authors
        self.publishedDate = source.publishedDate
        self.thumbnailImage = source.thumbnailImage
    }
}

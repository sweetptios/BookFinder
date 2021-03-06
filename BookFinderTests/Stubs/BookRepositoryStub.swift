//
//  BookRepositoryStub.swift
//  cosmeticsTests
//
//  Created by mine on 2020/02/05.
//  Copyright © 2020 sweetptdev. All rights reserved.
//

import Foundation
@testable import BookFinder

class BookSummaryRepositoryStub: IRepositoryStub<(books: [Book], totalCount: Int)>, IBookSummaryRepository {
    
    func fetchBooks(page: Int, keyword: String, maxResultCount: Int, completion: ((Result<(books: [Book], totalCount: Int), RepositoryError>) -> Void)?) {
        callCompletion(completion)
    }
}

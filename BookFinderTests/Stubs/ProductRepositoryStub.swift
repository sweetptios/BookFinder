//
//  ProductRepositoryStub.swift
//  cosmeticsTests
//
//  Created by mine on 2020/01/15.
//  Copyright © 2020 sweetptdev. All rights reserved.
//

import Foundation
@testable import BookFinder

class ProductSummaryRepositoryStub: IRepositoryStub<(books: [Book], totalCount: Int)>, IBookSummaryRepository {
    func fetchBooks(page: Int, keyword: String, completion: ((Result<(books: [Book], totalCount: Int), RepositoryError>) -> Void)?) {
        callCompletion(completion)
    }
}

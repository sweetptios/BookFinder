//
//  ProductRepositoryStub.swift
//  cosmeticsTests
//
//  Created by mine on 2020/01/15.
//  Copyright © 2020 sweetptdev. All rights reserved.
//

import Foundation
@testable import BookFinder

class ProductSummaryRepositoryStub: IRepositoryStub<[Book]>, IBookSummaryRepository {
    func fetchBooks(page: Int, keyword: String, completion: ((Result<[Book], RepositoryError>) -> Void)?) {
        callCompletion(completion)
    }
}

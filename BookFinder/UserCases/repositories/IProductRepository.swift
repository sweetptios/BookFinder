//
//  ProductIndexRepository.swift
//  Shoppingmall
//
//  Created by mine on 2019/12/03.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import Foundation

struct RepositoryError: Error {
    enum ErrorKind {
        case unknown
        case emptySearchResult(keyword: String)
        
        var defaultDescription: String {
            switch self {
            case let .emptySearchResult(keyword):
                return "\(keyword)에 대한 결과가 없습니다."
            case .unknown:
                return "알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요"
            }
        }
    }
    
    private(set) var kind: ErrorKind
    private let errorMessage: String?
    
    init(kind: ErrorKind, errorMessage: String? = nil) {
        self.kind = kind
        self.errorMessage = errorMessage
    }
    
    var localizedDescription: String { errorMessage ?? kind.defaultDescription }
}

protocol IBookSummaryRepository {
    func fetchBooks(page: Int, keyword: String, completion: ((Result<[Book],RepositoryError>) -> Void)?)
}

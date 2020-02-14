//
//  RepositoryStub.swift
//  cosmeticsTests
//
//  Created by mine on 2020/02/05.
//  Copyright © 2020 sweetptdev. All rights reserved.
//

import Foundation
@testable import BookFinder

class IRepositoryStub<T> {
    private var success = false
    private var testData: T?
    private(set) var testErrorMessage = "error"
    
    required init(networking: NetworkingServiceAvailable = NetworkingSeriveMock()) {}
    
    func setSuccess(_ flag: Bool) {
        success = flag
    }
    
    func setTestData(_ data: T) {
        testData = data
    }
    
    func callCompletion(_ completion: ((Result<T, RepositoryError>) -> Void)?) {
        if let testData = testData, success {
            completion?(.success(testData))
        } else {
            completion?(.failure(RepositoryError(kind: .unknown, errorMessage: testErrorMessage)))
        }
    }
}

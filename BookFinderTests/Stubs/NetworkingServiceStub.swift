//
//  NetworkingServiceStub.swift
//  cosmeticsTests
//
//  Created by mine on 2020/01/18.
//  Copyright © 2020 sweetptdev. All rights reserved.
//

import Foundation
@testable import BookFinder

class NetworkingServiceStub: INetworkingService {

    var success: Bool = false
    
    func setSuccess(_ flag: Bool) {
        success = flag
    }
    
    func request(_ api: ServerAPI, parameters: [String : Any]?) -> IDataRequest? {
        return DataRequestStub(success: success)
    }
}

struct DataRequestStub: IDataRequest {
    
    private(set) var success: Bool
    private let data = ["1","2"]
    private let error = ServerAPIResponseError()
    private let successJsonString = """
    {
      "statusCode": 200,
      "body": ["1","2"],
      "scanned_count": 20
    }
    """
    
    func response<T>(_ completion: @escaping (Result<T, ServerAPIResponseError>) -> Void) -> DataRequestStub where T : IServerAPIModel {
        if success {
            if let data = successJsonString.data(using: .utf8), let obj = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(obj))
            }
        } else {
            completion(.failure(error))
        }
        return self
    }
}


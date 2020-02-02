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

    private var success: Bool = false
    private var resultData: [String] = []
    
    func setSuccess(_ flag: Bool) {
        success = flag
    }
    
    func setResultData(_ data: [String]) {
        resultData = data
    }
    
    func request(_ api: ServerAPI, parameters: [String : Any]?) -> IDataRequest? {
        return DataRequestStub(success: success, resultData: resultData)
    }
}

struct DataRequestStub: IDataRequest {
    
    private(set) var success: Bool
    private(set) var resultData: [String]
    private let error = ServerAPIResponseError()
    private var successJsonString: String {
        var string: String = "[]"
        if resultData.isEmpty == false {
            string = "[\(String(describing: resultData.first))"
            resultData.forEach{ string += ",\"\($0)\""}
            string += "]"
        }
        return """
        {
          "items": \(string),
        }
        """
    }
    
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


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
    private var resultJson: String = ""
    
    func setSuccess(_ flag: Bool) {
        success = flag
    }
    
    func setResultJson(_ json: String) {
        resultJson = json
    }
    
    func request(_ api: ServerAPI, parameters: [String : Any]?) -> IDataRequest? {
        return DataRequestStub(success: success, resultJson: resultJson)
    }
}

struct DataRequestStub: IDataRequest {
    
    private(set) var success: Bool
    private(set) var resultJson: String
    private let error = ServerAPIResponseError()
    
    func response<T>(_ completion: @escaping (Result<T, ServerAPIResponseError>) -> Void) -> DataRequestStub where T : IServerAPIModel {
        if success {
            if let data = resultJson.data(using: .utf8), let obj = try? JSONDecoder().decode(T.self, from: data) {
                completion(.success(obj))
            } else {
                completion(.failure(ServerAPIResponseError(.decode)))
            }
        } else {
            completion(.failure(error))
        }
        return self
    }
}


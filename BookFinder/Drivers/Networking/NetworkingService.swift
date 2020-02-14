//
//  NetworkingService.swift
// BookFinder
//
//  Created by mine on 2020/02/05.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import Foundation
import Alamofire

//MARK: - INetworkingService

struct MainDataRequest: IDataRequest {
    
    private let source: DataRequest
    
    init(source: DataRequest) {
        self.source = source
    }
    
    func response<T: IServerAPIModel>(_ completion: @escaping (Swift.Result<T, ServerAPIResponseError>) -> Void) -> MainDataRequest {
        
        let dataRequest = source.responseData { (response) in
            if let data = response.value {
                if let obj = try? JSONDecoder().decode(ErrorResponseAPIModel.self, from: data), obj.isValid() {
                    completion(.failure(ServerAPIResponseError(statusCode: ServerAPIResponseCode(obj.error?.code ?? 0), errorMessage: obj.error?.message)))
                }
                else if let obj = try? JSONDecoder().decode(T.self, from: data), obj.isValid() {
                    completion(.success(obj))
                } else {
                    completion(.failure(ServerAPIResponseError(.decode)))
                }
            } else if let error = response.error {
                let statusCodeObj: ServerAPIResponseCode = ServerAPIResponseCode((error as NSError).code)
                completion(.failure(ServerAPIResponseError(statusCode:statusCodeObj, errorMessage: error.localizedDescription)))
            }
        }
        return MainDataRequest(source: dataRequest)
    }
}

struct NetworkingService: NetworkingServiceAvailable {
    
    func request(_ api: ServerAPI, parameters: [String : Any]? = nil) -> IDataRequest? {
        
        let dataRequest = AF.request(MainUrlRequest(api: api, parameters: parameters))
            .response { (response) in
                guard let request = response.request else { return }
                let urlString = request.url?.absoluteString ?? "unknown"
                let params = parameters != nil ? "\n params= \(String(describing: parameters!))" : ""
                var log: String = ""
                if let error = response.error  {
                    log = String(format:"HTTP Response Error= %d %@ \n URL= %@ %@)",
                                 (error as NSError).code,
                                 error.localizedDescription,
                                 urlString,
                                 params)
                } else {
                    log = String(format:"HTTP Response Success \n URL= %@ %@",
                                 urlString,
                                params)
                }
                print(log)
        }
        
        return MainDataRequest(source: dataRequest)
    }
}

//MARK: - Server API Error Response Model

struct ErrorResponseAPIModel: IServerAPIModel {
    let error: ErrorError?
    
    struct ErrorError: Codable {
        let code: Int?
        let message: String?
    }
    
    func isValid() -> Bool { error != nil}
}

//MARK: - Alamofire

extension ParameterEncodingType {
    var encoding: ParameterEncoding {
        switch self {
        case .URLEncoding:
            return Alamofire.URLEncoding.queryString
        }
    }
}

struct MainUrlRequest: URLRequestConvertible {
    private let api: ServerAPI
    private let parameters: Parameters?
    
    init(api: ServerAPI, parameters: Parameters?) {
        self.api = api
        self.parameters = parameters
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let path = api.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { throw URLRequestConvertibleError() }
        let url = try api.domain.rawValue.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = api.method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest = try api.parameterEncoding.encoding.encode(urlRequest, with: parameters)

        return urlRequest
    }
    
    struct URLRequestConvertibleError: Error {
        var localizedDescription: String { "Failed to make URLRequest object" }
    }
}

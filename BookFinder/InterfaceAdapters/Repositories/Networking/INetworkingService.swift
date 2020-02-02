//
//  INetworkingService.swift
//  Shoppingmall
//
//  Created by mine on 2020/01/06.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import Foundation

#warning("TODO 이름")
protocol INetworkingService {
     func request(_ api: ServerAPI, parameters: [String: Any]?) -> IDataRequest?
}

#warning("TODO 이름")
protocol IDataRequest {
    @discardableResult func response<T: IServerAPIModel>(_ completion: @escaping (Result<T, ServerAPIResponseError>) -> Void) -> Self
}

#warning("TODO - 이름 ServerAPIResponseSuccessModel")
protocol IServerAPIModel: Codable {
    func isValid() -> Bool
}

#warning("TODO - 이름  ServerAPIResponseErrorModel ")
//protocol IErrorServerAPIModel: IServerAPIModel {
//    var code: Int {get set}
//    var message: String? {get set}
//}

//MARK: - Server API Response Types

struct ServerAPIResponseCode: Equatable {

    static let unknown = ServerAPIResponseCode(0)
    static let success = ServerAPIResponseCode(200)
    private(set) var statusCode: Int
    
    init(_ statusCode: Int) {
        self.statusCode = statusCode
    }
    
    func equal(to statusCode: Int) -> Bool {
        self.statusCode == statusCode
    }
}

struct ServerAPIResponseError: Error {
    enum ErrorKind {
        case unknown
        case decode
    }
    private let errorMessage: String
    private(set) var kind: ErrorKind
    
    init(statusCode: ServerAPIResponseCode = .unknown, errorMessage: String? = nil) {
        kind = .unknown
        self.errorMessage = errorMessage ?? ""
        kind = decideKind(statusCode: statusCode)
    }
    
    init(_ kind: ErrorKind, errorMessage: String? = nil) {
        self.kind = kind
        self.errorMessage = errorMessage ?? ""
    }
    
    private func decideKind(statusCode: ServerAPIResponseCode) -> ErrorKind {
        switch statusCode {
        default:
            return .unknown
        }
    }

    var localizedDescription: String { errorMessage }
    
    func toRepositoryError() -> RepositoryError {
        switch self.kind {
        case .decode:
            return RepositoryError(kind: .unknown, errorMessage: localizedDescription)
        case .unknown:
            return RepositoryError(kind: .unknown, errorMessage: localizedDescription)
        }
    }
}


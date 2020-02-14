//
//  RestAPI.swift
//  cosmetics
//
//  Created by mine on 2020/02/03.
//  Copyright © 2020 sweetptdev. All rights reserved.
//

import Foundation

//MARK: - ServerAPI request information

enum ServerAPI {
    case books
}

enum ParameterEncodingType {
    case URLEncoding
}

enum HTTPMethodType: String {
    case get = "GET"
}

enum DomainType :String {
    case main = "https://www.googleapis.com"
}

extension ServerAPI {
    
    var parameterEncoding: ParameterEncodingType {
        switch self {
        default:
            return .URLEncoding
        }
    }
    
    var method: HTTPMethodType {
        switch self {
        default:
            return .get
        }
    }
    
    var domain: DomainType {
        switch self {
        default:
            return .main
        }
    }
    
    var path: String {
        switch self {
        case .books:
            return "books/v1/volumes"
        }
    }
}

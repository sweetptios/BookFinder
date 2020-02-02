//
//  RestAPI.swift
//  cosmetics
//
//  Created by mine on 2020/01/23.
//  Copyright © 2020 sweetptdev. All rights reserved.
//

import Foundation

//MARK: - ServerAPI request information

enum ServerAPI {
    case books
}

enum TParameterEncoding {
    case URLEncoding
}

enum THTTPMethod: String {
    case get = "GET"
}

enum TDomain :String {
    case main = "https://www.googleapis.com"
}

extension ServerAPI {
    
    var parameterEncoding: TParameterEncoding {
        switch self {
        default:
            return .URLEncoding
        }
    }
    
    var method: THTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var domain: TDomain {
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

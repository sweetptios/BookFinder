//
//  BookRepositoryMock.swift
// BookFinderTests
//
//  Created by mine on 2020/02/05.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import Foundation
import Stubber
@testable import BookFinder


struct NetworkingSeriveMock: INetworkingService {
    func request(_ api: ServerAPI, parameters: [String : Any]?) -> IDataRequest? {
        Stubber.invoke(request, args: escaping(api, parameters))
    }
}

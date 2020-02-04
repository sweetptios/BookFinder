//
//  ProductDetailMock.swift
//  BookFinderTests
//
//  Created by GOOK HEE JUNG on 2020/02/03.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import Foundation
import Stubber
@testable import BookFinder

class BookDetailOutputBoundaryMock: BookDetailOutputBoundary {
    
    func showBookDetail(_ url: URL?) {
        Stubber.invoke(showBookDetail, args: url)
    }
}

class BookDetailViewMock: BookDetailViewControllable {
    
    func showBookDetail(_ url: URL?) {
        Stubber.invoke(showBookDetail, args: url)
    }
}

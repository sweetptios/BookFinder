//
//  EtcMock.swift
//  BookFinderTests
//
//  Created by mine on 2020/02/11.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import Foundation
import Stubber
@testable import BookFinder

struct OtherAppServiceMock: OtherAppServiceAvailable {
    
    func viewInSafari(with url: URL) {
        Stubber.invoke(viewInSafari, args: url)
    }
}

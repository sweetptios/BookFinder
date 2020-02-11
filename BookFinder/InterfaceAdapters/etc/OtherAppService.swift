//
//  OtherAppService.swift
//  BookFinder
//
//  Created by mine on 2020/02/11.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import UIKit

struct OtherAppService: OtherAppServiceAvailable {
    
    func viewInSafari(with url: URL) {
        UIApplication.shared.open(url)
    }
}

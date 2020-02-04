//
//  NSObject+.swift
//  Shoppingmall
//
//  Created by mine on 2020/01/05.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import Foundation

extension NSObject {
    static var className: String { String(describing: self.self) }
}

//
//  Array+Extensions.swift
// BookFinder
//
//  Created by mine on 2020/02/01.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import Foundation

extension Array {
    public subscript (safe index: Int) -> Element? {
        get {
            return indices ~= index ? self[index] : nil
        }
        set {
            guard let value = newValue else { return }
            guard indices ~= index else { return }

            self[index] = value
        }
    }
}

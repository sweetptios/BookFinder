//
//  UIDevice+Extensions.swift
// BookFinder
//
//  Created by mine on 2020/02/03.
//  Copyright © 2019 sweetpt365. All rights reserved.
//
import UIKit

extension UIDevice {
    static var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

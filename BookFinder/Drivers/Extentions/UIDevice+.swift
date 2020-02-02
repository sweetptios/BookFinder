//
//  UIDevice+Extensions.swift
//  Shoppingmall
//
//  Created by mine on 2019/12/17.
//  Copyright © 2019 sweetpt365. All rights reserved.
//
import UIKit

extension UIDevice {
    static var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

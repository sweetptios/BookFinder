//
//  NSObject+Extensions.swift
// BookFinder
//
//  Created by mine on 2020/02/03.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.maskedCorners = corners
    }
}

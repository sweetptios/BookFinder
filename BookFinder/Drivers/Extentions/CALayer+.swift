//
//  CALayer.swift
// BookFinder
//
//  Created by mine on 2020/02/03.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import UIKit

extension CALayer {
    
    func setShadows(color: UIColor = .black,
                    alpha: Float = 1,
                    x: CGFloat = 0,
                    y: CGFloat = 0,
                    blur: CGFloat = 0,
                    spread: CGFloat = 0) {
        zeplinStyleShadows(color: color, alpha: alpha, x: x, y: y, blur: blur, spread: spread)
    }
    
    private func zeplinStyleShadows(color: UIColor,
                                    alpha: Float,
                                    x: CGFloat,
                                    y: CGFloat,
                                    blur: CGFloat,
                                    spread: CGFloat)
    {
          shadowColor = color.cgColor
          shadowOpacity = alpha
          shadowOffset = CGSize(width: x, height: y)
          shadowRadius = blur / 2.0
          if spread == 0 {
            shadowPath = nil
          } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
          }
    }
}

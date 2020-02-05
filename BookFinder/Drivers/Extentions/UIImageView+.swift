//
//  UIImageView+.swift
//  BookFinder
//
//  Created by GOOK HEE JUNG on 2020/02/06.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import Foundation
import Kingfisher

//MARK: - Download and Cache Images from the Web

extension UIImageView {
    func loadingImage(with url: URL?, placeholder: UIImage? = nil ) {
        kf.setImage(with: url, placeholder: placeholder)
    }
}

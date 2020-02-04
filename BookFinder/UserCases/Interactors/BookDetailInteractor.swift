//
//  BookDetailInteractor.swift
//  BookFinder
//
//  Created by GOOK HEE JUNG on 2020/02/03.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import UIKit
import Foundation

protocol BookDetailInputBoundary: class {
    init(outputBoundary: BookDetailOutputBoundary, itemId: String, detailInfoUrl: URL?)
    func viewDidLoad()
}

protocol BookDetailOutputBoundary: class {
    func showBookDetail(_ url: URL?)
}

class BookDetailInteractor {
    
    private let outputBoundary: BookDetailOutputBoundary!
    private let itemId: String
    private let detailInfoUrl: URL?
    
    required init(outputBoundary: BookDetailOutputBoundary, itemId: String, detailInfoUrl: URL?) {
        self.outputBoundary = outputBoundary
        self.itemId = itemId
        self.detailInfoUrl = detailInfoUrl
    }
}

extension BookDetailInteractor: BookDetailInputBoundary {
    
    func viewDidLoad() {
        outputBoundary.showBookDetail(detailInfoUrl)
    }
}

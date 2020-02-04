//
//  Book.swift
//  Shoppingmall
//
//  Created by mine on 2019/12/05.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import Foundation

struct Book {
    private(set) var id: String
    private(set) var title: String
    private(set) var authors: [String]
    private(set) var publishedDate: Date?
    private(set) var thumbnailImage: URL?
    private(set) var detailInfo: URL?

    init(id: String? = nil, title: String? = nil, authors: [String]? = nil, publishedDate: Date? = nil, thumbnailImage: URL? = nil, detailInfo: URL? = nil) {
        self.id = id ?? ""
        self.title = title ?? ""
        self.authors = authors ?? []
        self.publishedDate = publishedDate
        self.thumbnailImage = thumbnailImage
        self.detailInfo = detailInfo
     }
}

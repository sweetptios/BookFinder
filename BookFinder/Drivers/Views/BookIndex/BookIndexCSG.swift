//
//  BookIndexCSG.swift
//  Shoppingmall
//
//  Created by mine on 2020/01/04.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import UIKit

//MARK: - CollectionSectionGroup

final class BookIndexCSG: CollectionSectionGroup {

    enum SectionType: Int, CollectionSectionType {
        case book
    }
    
    var sections: [CollectionSection<SectionType>]
    
    init() {
        sections = [
            CollectionSection(type: .book, items: [])
        ]
    }
}

//MARK: - CollectionItemViewModel

struct BookIndexCollectionItemViewData: CollectionItemViewModel {
    private(set) var id: String
    private(set) var thumbnailUrl: URL?
    private(set) var title: String
    private(set) var author: String
    private(set) var publishedDate: String
}


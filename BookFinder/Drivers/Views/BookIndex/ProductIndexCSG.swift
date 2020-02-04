//
//  ProductIndexCSG.swift
//  Shoppingmall
//
//  Created by mine on 2020/01/04.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import UIKit

//MARK: - CollectionSectionGroup

final class ProductIndexCSG: CollectionSectionGroup {

    enum SectionType: Int, CollectionSectionType {
        case product
    }
    
    var sections: [CollectionSection<SectionType>]
    
    init() {
        sections = [
            CollectionSection(type: .product, items: [])
        ]
    }
}

//MARK: - CollectionItemViewModel

struct ProductIndexCollectionItemViewData: CollectionItemViewModel {
    private(set) var id: String
    private(set) var thumbnailUrl: URL?
    private(set) var title: String
    private(set) var author: String
    private(set) var publishedDate: String
}


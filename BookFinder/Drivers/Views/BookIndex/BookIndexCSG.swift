//
//  BookIndexCSG.swift
// BookFinder
//
//  Created by mine on 2020/02/04.
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

extension BookIndexItemViewData: CollectionItemViewData {}

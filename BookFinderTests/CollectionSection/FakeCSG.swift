//
//  FakeCollectionSectionGroup.swift
// BookFinderTests
//
//  Created by mine on 2020/02/05.
//  Copyright © 2020 sweetpt365. All rights reserved.
//

import UIKit
@testable import BookFinder


let bottomSpaceCellIdentifier = "bottomSpaceCellIdentifier"

final class FakeCSG: CollectionSectionGroup {

    enum SectionType: Int, CollectionSectionType {
        case imageGallery
        case productInformation
        case bottomSpace
    }

    var sections: [CollectionSection<SectionType>]
    
    init() {
        sections = [
            CollectionSection(type: .imageGallery,
                      items: [
                                CollectionItem(itemViewType: AItemView.self)
                              ]
                    ),
            CollectionSection(type: .productInformation,
                      items: [
                                CollectionItem(itemViewType: BItemView.self),
                                CollectionItem(itemViewType: CItemView.self)
                              ]
                    ),
            CollectionSection(type: .bottomSpace,
                      items: [
                                CollectionItem(itemViewType: UICollectionViewCell.self, reusableIdentifier: bottomSpaceCellIdentifier)
                             ]
                    )
         ]
    }
}

class AItemView: UICollectionViewCell, CollectionItemView {
    func configure(_ data: CollectionItemViewModel) {}
}

class BItemView: UICollectionViewCell, CollectionItemView {
    func configure(_ data: CollectionItemViewModel) {}
}

class CItemView: UICollectionViewCell, CollectionItemView {
    func configure(_ data: CollectionItemViewModel) {}
}
  
struct ACollectionItemViewData: CollectionItemViewModel {
    private(set) var a: Int
}

struct BCollectionItemViewData: CollectionItemViewModel {
    private(set) var b: String
}

struct CCollectionItemViewData: CollectionItemViewModel {
    private(set) var c: [Int]
}

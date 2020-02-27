//
//  CollectionSection.swift
// BookFinder
//
//  Created by mine on 2020/02/03.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Section Group

protocol CollectionSectionGroup: class {
    associatedtype T:CollectionSectionType
    var sections: [CollectionSection<T>] { get set }
}
extension CollectionSectionGroup {
    var sectionCount: Int { sections.count }
    
    func sectionType(at sectionIndex: Int) -> T? {
        sections[safe: sectionIndex]?.type
    }
    
    func itemCount(at sectionIndex: Int) -> Int {
        sections[safe: sectionIndex]?.itemCount ?? 0
    }
    
    func itemCount(at section: T) -> Int {
        itemCount(at: section.index)
    }
    
    func reusableIdentifier(at indexPath: IndexPath) -> String? {
        self[item: indexPath.section, indexPath.item]?.reusableIdentifier
    }
    
    func itemViewType(at indexPath: IndexPath) -> NSObject.Type? {
        self[item: indexPath.section, indexPath.item]?.itemViewType
    }
    
    //MARK: - addItems
    
    func addItems(_ items: [CollectionItem], at sectionIndex: Int) {
        sections[safe: sectionIndex]?.addItems(items)
    }
    
    func addItems(_ items: [CollectionItem], at section: T) {
        addItems(items, at: section.index)

    }
    
    //MARK: - CollectionItem object
    /**
     * @details usage -  xxCollectionGroup[item: 0,0]
     */
    private subscript(item sectionIndex: Int, itemIndex: Int) -> CollectionItem? {
        get { sections[safe: sectionIndex]?[itemIndex] }
    }
    
    //MARK: - CollectionItemViewModel object
    /**
     * @details usage -
     *  let indexPath = IndexPath(item:0, section:2) xxCollectionGroup[indexPath]
     */
    subscript(_ indexPath: IndexPath) -> CollectionItemViewData? {
        get { self[indexPath.section, indexPath.row] }
        set { self[indexPath.section, indexPath.row] = newValue }
    }

    subscript(section: T, itemIndex: Int) -> CollectionItemViewData? {
        get { self[section.index, itemIndex] }
        set { self[section.index, itemIndex] = newValue }
    }
    
    /**
     * @details usage -  xxCollectionGroup[0,0]
     */
    subscript(sectionIndex: Int, itemIndex: Int) -> CollectionItemViewData? {
        get { self[item: sectionIndex, itemIndex]?.itemViewModel }
        set {
            let theItem = self[item: sectionIndex, itemIndex]
            theItem?.setItemViewModel(newValue)
        }
    }
}

//MARK: - Section

protocol CollectionSectionType: RawRepresentable {
    var rawValue: Int { get }
}
extension CollectionSectionType {
    var index: Int { rawValue }
}

struct CollectionSection<T: CollectionSectionType> {
    private(set) var type: T
    private(set) var items: [CollectionItem] = []
}
extension CollectionSection {
    var itemCount: Int { items.filter{ $0.hasData }.count }

    subscript(index: Int) -> CollectionItem? {
        get { items[safe: index] }
        set { items[safe: index] = newValue }
    }
    
    mutating func addItems(_ items: [CollectionItem]) {
        self.items = items
    }
}

//MARK: - Item

final class CollectionItem {
    private(set) var itemViewModel: CollectionItemViewData?
    private(set) var itemViewType: NSObject.Type
    private(set) var reusableIdentifier: String

    init(itemViewData: CollectionItemViewData? = nil, itemViewType: NSObject.Type, reusableIdentifier: String? = nil) {
        self.itemViewModel = itemViewData
        self.itemViewType = itemViewType
        self.reusableIdentifier = reusableIdentifier ?? itemViewType.className
    }
}
extension CollectionItem {
    var hasData: Bool { itemViewModel != nil }
    func setItemViewModel(_ data: CollectionItemViewData?) {
        itemViewModel = data
    }
}

//MARK: - Item View

protocol CollectionItemView {
    func configure(_ data: CollectionItemViewData)
}

//MARK: - Model for View

protocol CollectionItemViewData {}

/**
 * @brief 공간만 차지하는 빈뷰일 경우 사용
 */
struct CollectionItemEmptyViewData: CollectionItemViewData {}



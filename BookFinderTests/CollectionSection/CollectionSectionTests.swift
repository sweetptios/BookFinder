//
//  ProductDetailCollectionSectionTests.swift
//  ShoppingmallTests
//
//  Created by mine on 2019/12/08.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import XCTest
import Stubber
import Nimble
@testable import BookFinder

struct FakeInputData {
    private(set) var a: Int = 0
    private(set) var b: String = ""
    private(set) var c: [Int] = [1,3,5]
}

class CollectionSectionGroupTests: XCTestCase {
    
    var collectionSectionGroup: FakeCSG!
    
    override func setUp() {
        collectionSectionGroup = FakeCSG()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_특정위치에데이터를설정하면_다시조회할수있다() {
        // [given]
        let testData = FakeInputData()
        // [when]
        let aItemViewData = ACollectionItemViewData(a: testData.a)
        collectionSectionGroup[0, 0] = aItemViewData
        // [then]
        let aItemViewData2 = collectionSectionGroup[0, 0] as! ACollectionItemViewData
        XCTAssertTrue(aItemViewData.a == aItemViewData2.a)
    }
    
    func test_데이터가설정되지않았다면_아이템개수가0이다() {
        // [given]
        // [when]
        let section0ItemCount = collectionSectionGroup.itemCount(at:0)
        let section1ItemCount = collectionSectionGroup.itemCount(at:1)
        // [then]
        expect(section0ItemCount).to(equal(0))
        expect(section1ItemCount).to(equal(0))
    }
    
    func test_데이터가설정되어있다면_해당아이템개수를알려줄수있다() {
        // [given]
        collectionSectionGroup[2,0] = ACollectionItemViewData(a:0)
        // [when]
        let sectionItemCount = collectionSectionGroup.itemCount(at:2)
        // [then]
        expect(sectionItemCount).to(equal(1))
    }
    
    func test_특정섹션인덱스를알려주면_섹션의타입을알아낼수있다() {
        // [given]
        // [when]
        let section = collectionSectionGroup.sectionType(at:2) ?? .imageGallery
        // [then]
        expect(section).to(equal(.bottomSpace))
    }
    
    func test_특정indexPath를알려주면_셀의resuableIdentifier를알아낼수있다() {
        // [given]
        // [when]
        let indexPath = IndexPath(item:0, section:2)
        let reusableIdentifier = collectionSectionGroup.reusableIdentifier(at: indexPath) ?? ""
        // [then]
        expect(reusableIdentifier).to(equal(bottomSpaceCellIdentifier))
    }
    
    func test_특정indexPath를알려주면_셀의타입을알아낼수있다() {
        // [given]
        // [when]
        let indexPath = IndexPath(item:0, section:2)
        let itemViewType = collectionSectionGroup.itemViewType(at: indexPath)
        // [then]
        expect(itemViewType!.className).to(equal(UICollectionViewCell.self.className))
    }
    
    func test_섹션에아이템목록을추가할수있다() {
        // [given]
        let sectionIndex = 0
        let itemCount = collectionSectionGroup.itemCount(at: sectionIndex)
        // [when]
        let itemA = CollectionItem(itemViewData: CollectionItemEmptyViewModel(), itemViewType: UICollectionViewCell.self, reusableIdentifier: UICollectionViewCell.className)
        let itemB = CollectionItem(itemViewData: CollectionItemEmptyViewModel(), itemViewType: UICollectionViewCell.self, reusableIdentifier: UICollectionViewCell.className)
        collectionSectionGroup.addItems([itemA, itemB], at: sectionIndex)
        // [then]
        expect(self.collectionSectionGroup.itemCount(at: sectionIndex)).to(equal(itemCount+2))
    }
    
    func test_섹션에아이템목록을추가할때_reusableIdentifier을생략하면_itemViewType의이름으로정해진다() {
        // [given]
        let indexPath = IndexPath(item: collectionSectionGroup.itemCount(at: 0), section: 0)
        // [when]
        let itemA = CollectionItem(itemViewData: CollectionItemEmptyViewModel(), itemViewType: AItemView.self)
        collectionSectionGroup.addItems([itemA], at: indexPath.section)
        // [then]
        expect(self.collectionSectionGroup.reusableIdentifier(at:indexPath)).to(equal(AItemView.className))
    }
    
    func test_SectionType으로도정보를조회할수있다() {
        // [given]
        let sectionType: FakeCSG.SectionType = .imageGallery
        let sectionIndex = 0
        let viewModel = ACollectionItemViewData(a: 100)
        collectionSectionGroup[sectionIndex,0] = viewModel
        // [when]
        let testViewModel = collectionSectionGroup[sectionType, 0] as! ACollectionItemViewData
        collectionSectionGroup.addItems([CollectionItem( itemViewData:CollectionItemEmptyViewModel(), itemViewType: UITableViewCell.self)], at: sectionType)
        let testCount = collectionSectionGroup.itemCount(at: sectionType)
        // [then]
        expect(viewModel.a).to(equal(testViewModel.a))
        expect(self.collectionSectionGroup.itemCount(at: sectionIndex)).to(equal(testCount))
    }
}


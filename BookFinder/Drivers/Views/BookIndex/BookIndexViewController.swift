//
//  BookIndexViewController.swift
//  Shoppingmall
//
//  Created by mine on 2019/12/02.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import UIKit

class BookIndexViewController: UIViewController {

    private var inputBoundary: BookIndexInputBoundary
    private var productDetailVCFactory: (String, URL?) -> UIViewController
    private var csg: BookIndexCSG
    
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout?
    @IBOutlet weak var searchBarView: UISearchBar?
    @IBOutlet weak var totalCountLabel: UILabel?
    #warning("이름 변경")
    @IBOutlet weak var filterView: UIView?
    #warning("TODO - 삭제 - xib에서도 없애댜함")
    @IBOutlet weak var filterButton: UIButton?
    @IBOutlet weak var filterViewTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView?
    private var moreRetryVisible: Bool = false

    init(inputBoundary: BookIndexInputBoundary, csg: BookIndexCSG, productDetailVCFactory: @escaping (String, URL?) -> UIViewController) {
        self.inputBoundary = inputBoundary
        self.productDetailVCFactory = productDetailVCFactory
        self.csg = csg
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        inputBoundary.viewDidLoad()
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = AppColor.c9013FE
        setupCollectionView()
        setupSearchBar()
        setupFilterView()
        setupFilterButton()
        setupLoadingIndicatorView()
    }
}

//MARK: - layout

struct BookIndexLayout {
    private static let columnCount = 3
    fileprivate static let sectionEdgeInset =  UIEdgeInsets(top: 24, left: 12, bottom: 0, right: 12)
    fileprivate static let minimumLineSpacing: CGFloat = 24
    fileprivate static let minimumInteritemSpacing: CGFloat = 24
    fileprivate static let footerHeight: CGFloat = 34*2 + 20
    fileprivate static var horizontalMargin: CGFloat { sectionEdgeInset.left + sectionEdgeInset.right + minimumInteritemSpacing*(CGFloat(max(0, columnCount-1))) }
    fileprivate static var itemSize: CGSize { CGSize(width: Self.thumbnailSize.width, height: Self.thumbnailSize.height + textAreaHeight ) }
    static var thumbnailSize: CGSize {
        let width = floor((UIScreen.main.bounds.width - horizontalMargin) / CGFloat(columnCount)); print(width)
        return CGSize(width: width, height: width / 0.81)
    }
    static var textAreaHeight: CGFloat { 91 }
}

extension BookIndexViewController {
    
    fileprivate func setupCollectionView() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.contentInset.top = 50
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(UINib(nibName: BookIndexItemCell.className, bundle: nil), forCellWithReuseIdentifier: BookIndexItemCell.className)
        collectionView?.register(UINib(nibName: MoreIndicatorView.className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MoreIndicatorView.className)
 
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "empty")
    }
    
    fileprivate func setupSearchBar() {
        searchBarView?.delegate = self
        searchBarView?.backgroundColor = AppColor.c9013FE
        // 13 이상인 경우 텍스트 필드 배경색이 상위뷰의 배경색과 같음. 미만인 경우는 하얀색이라서 13 이상인 경우만 배경색을 바꿔줌
        if #available(iOS 13.0, *) {
            searchBarView?.searchTextField.backgroundColor = AppColor.cFFFFFF
        }
        searchBarView?.placeholder = "읽고싶은 책을 찾아보세요"
        searchBarView?.backgroundImage = UIImage()
    }
    
    fileprivate func setupFilterView() {
        filterView?.layer.setShadows(color: AppColor.c33_47_62_01 ?? .lightGray, y: 1)
    }
    
    fileprivate func setupFilterButton() {
        filterButton?.titleLabel?.font = AppFont.AppleSDGothicNeo_Bold14
        filterButton?.setTitleColor(AppColor.c000000, for: .normal)
        filterButton?.setTitleColor(AppColor.c000000, for: .selected)
        filterButton?.setImage(UIImage(named: "keyboard_arrow_down-24px"), for: .normal)
        filterButton?.setImage(UIImage(named: "keyboard_arrow_up-24px"), for: .selected)
        filterButton?.imageView?.tintColor = AppColor.c000000
        filterButton?.adjustsImageWhenHighlighted = false
        filterButton?.semanticContentAttribute = .forceRightToLeft
    }
    
    fileprivate func setupLoadingIndicatorView() {
        loadingIndicatorView?.stopAnimating()
        loadingIndicatorView?.hidesWhenStopped = true
    }
}

extension BookIndexViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > 0 {
            let maxY: CGFloat = 0
            let minY: CGFloat = -50
            let offsetY = -(minY + scrollView.contentOffset.y*0.25)
            filterViewTopConstraint?.constant = min(maxY, max(minY, offsetY))
        }
    }
}

//MARK: - about UICollectionView

extension BookIndexViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        BookIndexLayout.minimumLineSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        BookIndexLayout.minimumInteritemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputBoundary.didSelectBook(index: indexPath.item)
    }
    //footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MoreIndicatorView.className, for: indexPath)
        if let view = view as? MoreIndicatorView {
            view.registerRetryAction { [weak self] in
                self?.inputBoundary.didRetryOnSeeingMore()
            }
            view.activateRetry(moreRetryVisible)
        }
        return view
    }
    //footer
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            if moreRetryVisible == false {
                inputBoundary.fetchNextBooks()
            }
        }
    }
}

extension BookIndexViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        csg.itemCount(at: section)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let reusableIdentifier = csg.reusableIdentifier(at: indexPath), let data = csg[indexPath] else { return  collectionView.dequeueReusableCell(withReuseIdentifier: "empty", for: indexPath) }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath)
            
        if let cell = cell as? CollectionItemView {
            cell.configure(data)
        }
        return cell
    }
}

extension BookIndexViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        BookIndexLayout.sectionEdgeInset
    }
    //footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard csg.itemCount(at: .product) > 0 else { return .zero }
        return CGSize(width: collectionView.bounds.width, height: BookIndexLayout.footerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        BookIndexLayout.itemSize
    }
}

//MARK: - transition animation

extension BookIndexViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return NicePresentAnimationController()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        NiceDismissAnimationController()
    }
}

//MARK: - UISearchBarDelegate

extension BookIndexViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        inputBoundary.didSelectKeywordSearch(searchBar.text ?? "")
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        inputBoundary.didEndEditingSearchKeyword()
    }
}

//MARK: - IBookIndexView

extension BookIndexViewController: BookIndexViewControllable {
    
    func showBooks(_ products: [BookIndexCollectionItemViewData]) {
        let items = products.map {
            CollectionItem(itemViewData: $0, itemViewType: BookIndexItemCell.self)
        }
        csg.addItems(items, at: .product)
        collectionView?.reloadData()
    }
    
    func alertErrorMessage(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        present(alert, animated: true)
    }
    
    func showBookDetail(id: String, detailInfoUrl: URL?) {
        let viewController = productDetailVCFactory(id, detailInfoUrl)
        present(viewController, animated: true, completion: nil)
    }
    
    func showSearchKeyword(_ keyword: String) {
        searchBarView?.text = keyword
    }
    
    func showTotalCount(_ count: String) {
        totalCountLabel?.text = count
    }
    
    func activateRetryOnSeeingMore() {
        moreRetryVisible = true
        collectionView?.reloadData()
    }
    
    func deactivateRetryOnSeeingMore() {
        moreRetryVisible = false
        collectionView?.reloadData()
    }
    
    func showLoadingIndicator() {
        loadingIndicatorView?.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicatorView?.stopAnimating()
    }
    
    func scrollToTop() {
        collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
}

//
//  BookIndexViewController.swift
// BookFinder
//
//  Created by mine on 2020/02/03.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import UIKit

class BookIndexViewController: UIViewController {

    private var inputBoundary: BookIndexInputBoundary

    private var csg: BookIndexCSG
    
    @IBOutlet weak var collectionView: UICollectionView?
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout?
    @IBOutlet weak var searchBarView: UISearchBar?
    @IBOutlet weak var totalCountLabel: UILabel?
    @IBOutlet weak var countView: UIView?
    @IBOutlet weak var countViewTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var loadingIndicatorView: UIActivityIndicatorView?
    private var moreRetryVisible: Bool = false

    init(inputBoundary: BookIndexInputBoundary, csg: BookIndexCSG) {
        self.inputBoundary = inputBoundary
        self.csg = csg
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        inputBoundary.viewIsReady(columnCount: BookIndexLayout.columnCount)
    }
}

//MARK: - setup views

struct BookIndexLayout {
    //MARK: - about collection view
    fileprivate static let columnCount = 3
    fileprivate static let sectionEdgeInset =  UIEdgeInsets(top: 24, left: 12, bottom: 0, right: 12)
    fileprivate static let minimumLineSpacing: CGFloat = 24
    fileprivate static let minimumInteritemSpacing: CGFloat = 24
    fileprivate static let headerHeight: CGFloat = 50
    fileprivate static let footerHeight: CGFloat = 34*2 + 20
    //MARK: - about cell
    private static var itemHorizontalMargin: CGFloat {
        sectionEdgeInset.left + sectionEdgeInset.right + minimumInteritemSpacing*(CGFloat(max(0, columnCount-1)))
    }
    static var itemThumbnailSize: CGSize {
        let width = floor((UIScreen.main.bounds.width - itemHorizontalMargin) / CGFloat(columnCount))
        return CGSize(width: width, height: width / 0.81)
    }
    fileprivate static var itemSize: CGSize {
        let textAreaHeight: CGFloat = 91
        return CGSize(width: Self.itemThumbnailSize.width, height: Self.itemThumbnailSize.height + textAreaHeight )
    }
}

extension BookIndexViewController {
    
    private func setupViews() {
        view.backgroundColor = AppColor.Background.purple
        setupCollectionView()
        setupSearchBar()
        setupFilterView()
        setupLoadingIndicatorView()
    }
    
    private func setupCollectionView() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.contentInset.top = BookIndexLayout.headerHeight
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(UINib(nibName: BookIndexItemCell.className, bundle: nil), forCellWithReuseIdentifier: BookIndexItemCell.className)
        collectionView?.register(UINib(nibName: MoreIndicatorView.className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MoreIndicatorView.className)
 
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "empty")
    }
    
    private func setupSearchBar() {
        searchBarView?.delegate = self
        searchBarView?.barTintColor = AppColor.Background.purple
        searchBarView?.backgroundColor = AppColor.Background.purple
        // 13 이상인 경우 텍스트 필드 배경색이 상위뷰의 배경색과 같음. 미만인 경우는 하얀색이라서 13 이상인 경우만 배경색을 바꿔줌
        if #available(iOS 13.0, *) {
            searchBarView?.searchTextField.backgroundColor = AppColor.Background.white
        }
        searchBarView?.placeholder = "읽고싶은 책을 찾아보세요"
        searchBarView?.backgroundImage = UIImage()
    }
    
    private func setupFilterView() {
        totalCountLabel?.textColor = AppColor.darkNavy
        totalCountLabel?.font = AppFont.AppleSDGothicNeo_Bold14
        countView?.clipsToBounds = false
        countView?.layer.setShadows(color: AppColor.Background.darkNavyShadow ?? .lightGray, y: 2, blur: 4)
    }
    
    private func setupLoadingIndicatorView() {
        loadingIndicatorView?.stopAnimating()
        loadingIndicatorView?.hidesWhenStopped = true
    }
}

extension BookIndexViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height > 0 {
            let maxY: CGFloat = 0
            let minY: CGFloat = -BookIndexLayout.headerHeight
            let offsetY = -(minY + scrollView.contentOffset.y*0.25)
            countViewTopConstraint?.constant = min(maxY, max(minY, offsetY))
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
                inputBoundary.didSelectSeeingMore()
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
        guard csg.itemCount(at: .book) > 0 else { return .zero }
        return CGSize(width: collectionView.bounds.width, height: BookIndexLayout.footerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        BookIndexLayout.itemSize
    }
}

//MARK: - transition animation

extension BookIndexViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        NicePresentAnimationController()
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
    
    func showBooks(_ products: [BookIndexItemViewData]) {
        let items = products.map {
            CollectionItem(itemViewData: $0, itemViewType: BookIndexItemCell.self)
        }
        csg.addItems(items, at: .book)
        collectionView?.reloadData()
    }
    
    func showErrorMessage(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        present(alert, animated: true)
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
    
    func moveToTop() {
        // 로드된 셀이 없을 때 호출되면 invalid IndexPath warning 발생하는 문제 해결
        if csg.itemCount(at:.book) > 0 {
            collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
}

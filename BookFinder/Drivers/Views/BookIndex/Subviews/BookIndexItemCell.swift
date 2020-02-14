//
//  BookIndexItemCell.swift
// BookFinder
//
//  Created by mine on 2020/02/03.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import UIKit

class BookIndexItemCell: UICollectionViewCell, CollectionItemView {
    @IBOutlet weak var thumbnailImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var authorsLabel: UILabel?
    @IBOutlet var publishedDateLabel: UILabel?
    @IBOutlet private var thumbnailImageWidthConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    func configure(_ data: CollectionItemViewData) {
        if let data = data as? BookIndexItemViewData {
            thumbnailImageView?.loadingImage(with: data.thumbnailUrl, placeholder: UIImage(named: "no_cover_thumb"))
            titleLabel?.text = data.title
            authorsLabel?.text = data.author
            publishedDateLabel?.text = data.publishedDate
        }
    }
    
    private func setupViews() {
        setupImageView()
        setupTitleView()
        setupAuthorsView()
        setupPublishedDateView()
    }
}

extension BookIndexItemCell {
    
    private func setupImageView() {
        thumbnailImageWidthConstraint?.constant = BookIndexLayout.itemThumbnailSize.width
        thumbnailImageView?.contentMode = .scaleAspectFill
        thumbnailImageView?.layer.cornerRadius = 1
        thumbnailImageView?.layer.masksToBounds = true
    }
    
    private func setupTitleView() {
        titleLabel?.font = AppFont.NotoSansCJKkr_Black13
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.8
        titleLabel?.textColor = AppColor.darkNavy
    }
    
    private func setupAuthorsView() {
        authorsLabel?.font = AppFont.NotoSansCJKkr_Bold12
        authorsLabel?.adjustsFontSizeToFitWidth = true
        authorsLabel?.minimumScaleFactor = 0.8
        authorsLabel?.textColor = AppColor.gray
    }
    
    private func setupPublishedDateView() {
        publishedDateLabel?.font = AppFont.NotoSansCJKkr_Bold11
        publishedDateLabel?.adjustsFontSizeToFitWidth = true
        publishedDateLabel?.minimumScaleFactor = 0.8
        publishedDateLabel?.textColor = AppColor.gray
    }
}


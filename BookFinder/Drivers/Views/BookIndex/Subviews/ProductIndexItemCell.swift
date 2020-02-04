//
//  ProductIndexItemCell.swift
//  Shoppingmall
//
//  Created by mine on 2019/12/05.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import UIKit
import Kingfisher

class ProductIndexItemCell: UICollectionViewCell, CollectionItemView {
    @IBOutlet weak var thumbnailImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var authorsLabel: UILabel?
    @IBOutlet var publishedDateLabel: UILabel?
    @IBOutlet private var thumbnailImageWidthConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    func configure(_ data: CollectionItemViewModel) {
        if let data = data as? ProductIndexCollectionItemViewData {
            #warning("TODO - 어댑터")
            thumbnailImageView?.kf.setImage(with: data.thumbnailUrl, placeholder: UIImage(named: "no_cover_thumb"))
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

extension ProductIndexItemCell {
    
    private func setupImageView() {
        thumbnailImageWidthConstraint?.constant = ProductIndexLayout.thumbnailSize.width
        thumbnailImageView?.contentMode = .scaleAspectFill
        thumbnailImageView?.layer.cornerRadius = 1
        thumbnailImageView?.layer.masksToBounds = true
        thumbnailImageView?.layer.borderColor = AppColor.c24_24_80_004?.cgColor
        thumbnailImageView?.layer.borderWidth = 1.0
        thumbnailImageView?.layer.setShadows(color: AppColor.c24_24_80_004 ?? UIColor.lightGray, spread: 1)
    }
    
    private func setupTitleView() {
        titleLabel?.font = AppFont.NotoSansCJKkr_Black13
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.8
        titleLabel?.textColor = AppColor.c141428
    }
    
    private func setupAuthorsView() {
        authorsLabel?.font = AppFont.NotoSansCJKkr_Bold12
        authorsLabel?.adjustsFontSizeToFitWidth = true
        authorsLabel?.minimumScaleFactor = 0.8
        authorsLabel?.textColor = AppColor.cABABC4
    }
    
    private func setupPublishedDateView() {
        publishedDateLabel?.font = AppFont.NotoSansCJKkr_Bold11
        publishedDateLabel?.adjustsFontSizeToFitWidth = true
        publishedDateLabel?.minimumScaleFactor = 0.8
        publishedDateLabel?.textColor = AppColor.cABABC4
    }
}


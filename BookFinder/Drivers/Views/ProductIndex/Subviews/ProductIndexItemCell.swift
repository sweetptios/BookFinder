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
    @IBOutlet weak var titleView: UILabel?
    @IBOutlet weak var priceLabelView: UILabel?
    @IBOutlet private var thumbnailImageWidthConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    func configure(_ data: CollectionItemViewModel) {
        if let data = data as? ProductIndexCollectionItemViewData {
            thumbnailImageView?.kf.setImage(with: data.thumbnailUrl)
            titleView?.text = data.title
            priceLabelView?.text = data.author
        }
    }
    
    private func setupViews() {
        setupImageView()
        setupTitleView()
        setupPriceView()
    }
}

extension ProductIndexItemCell {
    
    private func setupImageView() {
        thumbnailImageWidthConstraint?.constant = ProductIndexLayout.thumbnailWidth
        thumbnailImageView?.contentMode = .scaleAspectFill
        thumbnailImageView?.layer.cornerRadius = 14
        thumbnailImageView?.layer.masksToBounds = true
        thumbnailImageView?.layer.borderColor = AppColor.c24_24_80_004?.cgColor
        thumbnailImageView?.layer.borderWidth = 1.0
        thumbnailImageView?.layer.setShadows(color: AppColor.c24_24_80_004 ?? UIColor.lightGray, spread: 1)
    }
    
    private func setupTitleView() {
        titleView?.font = AppFont.NotoSansCJKkr_Black14
        titleView?.textColor = AppColor.c141428
    }
    
    private func setupPriceView() {
        priceLabelView?.font = AppFont.NotoSansCJKkr_Bold14
        priceLabelView?.textColor = AppColor.cABABC4
    }
}


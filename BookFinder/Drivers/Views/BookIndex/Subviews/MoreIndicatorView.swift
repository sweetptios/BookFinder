//
//  MoreIndicatorReusableView.swift
// BookFinder
//
//  Created by mine on 2020/02/05.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import UIKit

class MoreIndicatorView: UICollectionReusableView {

    @IBOutlet weak var indicator: UIImageView?
    @IBOutlet weak var retryButton: UIButton?
    typealias RetryActionType = (() -> Void)
    private var retryAction: RetryActionType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }
    
    private func setupViews() {
        activateRetry(false)
        setupIndicator()
        setupRetry()
    }

    private func setupIndicator() {
        if let myImage = UIImage(named: "compass") {
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            indicator?.image = tintableImage
        }
        indicator?.tintColor = AppColor.gray
        let animations = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animations.repeatCount = .infinity
        animations.beginTime = CACurrentMediaTime() + 0.5
        animations.duration = 1.5;
        animations.values = [NSNumber(floatLiteral: 0),
                             NSNumber(floatLiteral: .pi), // 180도
                             NSNumber(floatLiteral: 2 * .pi),
                             NSNumber(floatLiteral: 3 * .pi),
                             NSNumber(floatLiteral: 4 * .pi)]
        animations.keyTimes = [NSNumber(floatLiteral: 0.0),
                               NSNumber(floatLiteral: 1/11),
                               NSNumber(floatLiteral: 2/11),
                               NSNumber(floatLiteral: 3/11),
                               NSNumber(floatLiteral: 5/11)]
        animations.isRemovedOnCompletion = false
        indicator?.layer.add(animations, forKey: "rotate-layer")
    }
    
    private func setupRetry() {
        retryButton?.setTitle("재시도", for: .normal)
        retryButton?.setTitleColor(AppColor.gray, for: .normal)
        retryButton?.addTarget(self, action: #selector(didTapRetryButton), for: .touchUpInside)
    }
    
    @objc
    func didTapRetryButton(_ sender: UIButton) {
        retryAction?()
    }
    
    func activateRetry(_ flag: Bool) {
        retryButton?.isHidden = !flag
        indicator?.isHidden = flag
    }
    
    func registerRetryAction(_ action: @escaping RetryActionType) {
        retryAction = action
    }
}





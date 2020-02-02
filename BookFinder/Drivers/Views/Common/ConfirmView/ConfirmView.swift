//
//  ConfirmView.swift
//  Shoppingmall
//
//  Created by mine on 2019/12/16.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import UIKit
import SnapKit

protocol ContainsFloatingConfirmView: class {
    var floatingView: ConfirmView {get set}
}

extension ContainsFloatingConfirmView where Self: UIViewController {
    func addConfirmView() {
        floatingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(floatingView)
        floatingView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(floatingView.frame.height)
        }
    }
    
    func showConfirmView(animated: Bool) {
        updateBottomMargin(0)
        if animated {
            UIView.animate(withDuration: 1.2,
                           delay: 0,
                           usingSpringWithDamping: 0.6,
                           initialSpringVelocity: 0,
                           options: .curveEaseOut,
                           animations:{
                                self.view.layoutIfNeeded()
                           })
        }
    }
    
    func hideConfirmView(animated: Bool) {
        updateBottomMargin(floatingView.frame.height)
        if animated {
            UIView.animate(withDuration: 1.5,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                                self.view.layoutIfNeeded()
                           })
        }
    }
    
    private func updateBottomMargin(_ margin: CGFloat)  {
        floatingView.snp.updateConstraints() {
            $0.bottom.equalToSuperview().offset(margin)
        }
    }
}


class ConfirmView: UIView {
    @IBOutlet var confirmButton: UIButton?
    @IBOutlet var titleLabel: UILabel?
    var setupBlock: ((ConfirmView) -> Void)?
    var pressedConfirmButtonBlock: ((UIButton) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        titleLabel?.textColor = AppColor.cFFFFFF
        titleLabel?.font = AppFont.NotoSansCJKkr_Black18
        confirmButton?.backgroundColor = AppColor.c9013FE
        confirmButton?.layer.cornerRadius = 14
        confirmButton?.layer.masksToBounds = true
    }

    override func updateConstraints() {
        setupBlock?(self)
        super.updateConstraints()
    }

    @IBAction func pressedConfirmButton(_ sender: UIButton) {
        pressedConfirmButtonBlock?(sender)
    }

    func setTitle(_ title: String?) {
        titleLabel?.text = title
    }
}

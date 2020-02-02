//
//  NiceAnimationController.swift
//  Shoppingmall
//
//  Created by mine on 2019/12/12.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import UIKit

let blackViewTag: Int = 100

class NiceDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0.2 }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        
        let blackView = transitionContext.containerView.viewWithTag(blackViewTag)

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                            fromVC.view.transform = CGAffineTransform(translationX: 0, y: fromVC.view.bounds.height)
                            blackView?.backgroundColor = .clear }
                      ) { _ in
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                      }
    }
}

class NicePresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 1 }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to), let toView = transitionContext.view(forKey: .to) else { return }

        let finalFrame = transitionContext.finalFrame(for: toVC)
        let containerView = transitionContext.containerView
        
        let blackView: UIView = {
            let view = UIView(frame: fromVC.view.bounds)
            view.tag = blackViewTag
            view.backgroundColor = .clear
            return view
        }()
        containerView.addSubview(blackView)
        containerView.addSubview(toView)
        
        toView.frame = finalFrame
        toView.transform = CGAffineTransform(translationX: 0, y: toView.frame.height)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                            blackView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                            toView.transform = CGAffineTransform.identity }
                      ) { _ in
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                      }
    }
}

//
//  NiceAnimationController.swift
// BookFinder
//
//  Created by mine on 2020/2/5.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import UIKit

class NiceDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 0.3 }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                            fromVC.view.transform = CGAffineTransform(translationX: 0, y: fromVC.view.bounds.height)
                        }
                      ) { _ in
                                
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                      }
    }
}

class NicePresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { 1 }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to), let toView = transitionContext.view(forKey: .to) else { return }

        let finalFrame = transitionContext.finalFrame(for: toVC)
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        
        toView.frame = finalFrame
        toView.transform = CGAffineTransform(translationX: 0, y: toView.frame.height)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0,
                       usingSpringWithDamping: 0.75,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                            toView.transform = CGAffineTransform.identity }
                      ) { _ in
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                      }
    }
}

//
//  AnimatedTransitioning.swift
//  NavigationControllerTransitioningApp
//
//  Created by Imanou on 04/05/2018.
//  Copyright © 2018 Imanou Petit. All rights reserved.
//

import UIKit

class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    var reverse: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: .to)!
        let fromViewController = transitionContext.viewController(forKey: .from)!
        let toView = toViewController.view!
        let fromView = fromViewController.view!
        let direction: CGFloat = reverse ? -1 : 1
        let const: CGFloat = -0.005
        
        toView.layer.anchorPoint = CGPoint(x: direction == 1 ? 0 : 1, y: 0.5)
        fromView.layer.anchorPoint = CGPoint(x: direction == 1 ? 1 : 0, y: 0.5)
        
        var viewFromTransform: CATransform3D = CATransform3DMakeRotation(direction * .pi / 2, 0, 1, 0)
        var viewToTransform: CATransform3D = CATransform3DMakeRotation(-direction * .pi / 2, 0, 1, 0)
        viewFromTransform.m34 = const
        viewToTransform.m34 = const
        
        containerView.transform = CGAffineTransform(translationX: direction * containerView.frame.size.width / 2, y: 0)
        toView.layer.transform = viewToTransform
        containerView.addSubview(toView)
        
        let animations = {
            containerView.transform = CGAffineTransform(translationX: -direction * containerView.frame.size.width / 2, y: 0)
            fromView.layer.transform = viewFromTransform
            toView.layer.transform = CATransform3DIdentity
        }
        let completion = { (_: Bool) in
            containerView.transform = .identity
            fromView.layer.transform = CATransform3DIdentity
            toView.layer.transform = CATransform3DIdentity
            fromView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            if transitionContext.transitionWasCancelled {
                toView.removeFromSuperview()
            } else {
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: animations, completion: completion)
    }
    
    deinit {
        print("Quit \(type(of: self))")
    }
    
}

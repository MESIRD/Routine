//
//  MainViewControllerAnimator.swift
//  Routine
//
//  Created by mesird on 23/03/2017.
//  Copyright © 2017 mesird. All rights reserved.
//

import UIKit

enum AnimatorType {
    case present, dismiss
}

class MainViewControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    
    public var animatorType: AnimatorType?
    public var startFrame: CGRect?
    private var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        self.transitionContext = transitionContext
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView
        
        if animatorType! == .present {
            // present a view controller
            containerView.addSubview((toVC?.view)!)
            let maskLayer = CAShapeLayer()
            toVC?.view.layer.mask = maskLayer
            
            let beginPath = UIBezierPath(roundedRect: startFrame!, cornerRadius: 8)
            let endPath = UIBezierPath(roundedRect: UIScreen.main.bounds, cornerRadius: 0.01)
            maskLayer.frame = (toVC?.view.frame)!
            maskLayer.path = beginPath.cgPath
            
            let maskAnimation = CABasicAnimation(keyPath: "path")
            maskAnimation.fromValue = beginPath.cgPath
            maskAnimation.toValue  = endPath.cgPath
            maskAnimation.duration = self.transitionDuration(using: transitionContext)
            maskAnimation.delegate = self
            maskAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            let blackView: UIView = UIView(frame: (fromVC?.view.bounds)!)
            blackView.backgroundColor = UIColor.black
            blackView.alpha = 0
            blackView.tag = 101
            fromVC?.view.addSubview(blackView)
            
            // first animation
            toVC?.view.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                toVC?.view.alpha = 1
                blackView.alpha = 0.5
                fromVC?.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { (finish: Bool) in
                maskLayer.path = endPath.cgPath
                maskLayer.add(maskAnimation, forKey: "path")
            })
        } else {
            // dismiss current view controller
            containerView.addSubview((toVC?.view)!)
            containerView.bringSubview(toFront: (fromVC?.view)!)
            fromVC?.view.layer.cornerRadius = 10
            fromVC?.view.layer.masksToBounds = true
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                fromVC?.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { (finished: Bool) in
                var fromVCFrame = fromVC?.view.frame
                fromVCFrame?.origin.y = screenHeight
                let maskView = toVC?.view.viewWithTag(101)
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                    fromVC?.view.frame = fromVCFrame!
                    maskView?.alpha = 0
                }, completion: { (finished: Bool) in
                    maskView?.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            })
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(!(self.transitionContext?.transitionWasCancelled)!)
        let fromVC = self.transitionContext?.viewController(forKey: UITransitionContextViewControllerKey.from)
        fromVC?.view.layer.mask = nil
        fromVC?.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.transitionContext?.view(forKey: UITransitionContextViewKey.to)?.layer.mask = nil
    }
}

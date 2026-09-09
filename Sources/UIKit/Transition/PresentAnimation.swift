//
//  DTBBasePresentTransition.swift
//  SmartSales
//
//  Created by moonShadow on 2026/8/28
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {
    
    /// 代理
    @objc(DTBPresentTransitioningHandler)
    public final class PresentTransitioningHandler: NSObject, UIViewControllerTransitioningDelegate {
        
        private let animation = PresentAnimation()
        
        public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            return PresentPresentationController(presentedViewController: presented, presenting: presenting)
        }
        
        public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return animation.to(.present)
        }
        
        public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return animation.to(.dismiss)
        }
    }
    
    /// 转场控制器
    @objc(DTBPresentPresentationController)
    public final class PresentPresentationController: UIPresentationController {
        
        private lazy var scrimView: UIView = {
            let v = UIView()
            v.backgroundColor = UIColor.dtb.create("scrim")
            v.alpha = 0
            v.isUserInteractionEnabled = false
            return v
        }()
        
        public override func presentationTransitionWillBegin() {
            guard let containerView else { return }
            scrimView.frame = containerView.bounds
            scrimView.alpha = 0
            containerView.insertSubview(scrimView, at: 0)
            
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
                self.scrimView.alpha = 1
            })
        }
        
        public override func dismissalTransitionWillBegin() {
            presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
                self.scrimView.alpha = 0
            })
        }
        
        public override func containerViewWillLayoutSubviews() {
            super.containerViewWillLayoutSubviews()
            scrimView.frame = containerView?.bounds ?? .zero
        }
        
        public override var frameOfPresentedViewInContainerView: CGRect {
            return containerView?.bounds ?? .zero
        }
    }
    
    /// 转场动画
    @objc(DTBPresentAnimation)
    public final class PresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
        
        public enum Kind {
            case present
            case dismiss
        }
        
        private var kind: Kind?
        
        public func to(_ kind: Kind) -> Self {
            self.kind = kind
            return self
        }
        
        public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.3
        }
        
        public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let container = transitionContext.containerView
            let size = container.bounds.size
            
            guard let k = kind else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
            }
            
            switch k {
            case .present:
                guard let toView = transitionContext.view(forKey: .to) else {
                    transitionContext.completeTransition(false)
                    return
                }
                container.addSubview(toView)
                toView.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    toView.frame = container.bounds
                }) { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled && finished)
                }
                
            case .dismiss:
                guard let fromView = transitionContext.view(forKey: .from) else {
                    transitionContext.completeTransition(false)
                    return
                }
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    fromView.frame = CGRect(x: 0, y: size.height, width: size.width, height: size.height)
                }) { finished in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled && finished)
                }
            }
        }
    }
    
}

//
//  AlertAnimation.swift
//  DTBKit
//
//  Created by moonShadow on 2023/8/15
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {

    /// alert 转场代理：固定居中缩放动画。
    @objc(DTBAlertTransitioningHandler)
    public final class AlertTransitioningHandler: NSObject, UIViewControllerTransitioningDelegate {

        private let animation = AlertAnimation()

        public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            return AlertPresentationController(presentedViewController: presented, presenting: presenting)
        }

        public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return animation.to(.centerShow)
        }

        public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return animation.to(.centerHide)
        }
    }

    /// alert 转场控制器：负责视觉 scrim 的淡入淡出。
    @objc(DTBAlertPresentationController)
    public final class AlertPresentationController: UIPresentationController {

        private lazy var scrimView: UIView = {
            let v = UIView()
            v.backgroundColor = UIColor.dtb.create("dtb.mask5")
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

    /// alert 转场动画：仅 centerShow / centerHide，仿系统 alert 缩放淡入淡出。
    @objc(DTBAlertAnimation)
    public final class AlertAnimation: NSObject, UIViewControllerAnimatedTransitioning {

        public enum Kind {
            case centerShow
            case centerHide
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

            guard let k = kind else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
            }

            switch k {
            case .centerShow:
                guard let toView = transitionContext.view(forKey: .to) else {
                    transitionContext.completeTransition(false)
                    return
                }
                container.addSubview(toView)
                toView.frame = container.bounds
                toView.alpha = 0
                toView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    toView.alpha = 1
                    toView.transform = .identity
                }) { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled && finished)
                }

            case .centerHide:
                guard let fromView = transitionContext.view(forKey: .from) else {
                    transitionContext.completeTransition(false)
                    return
                }
                fromView.alpha = 1
                fromView.transform = .identity
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    fromView.alpha = 0
                    fromView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                }) { finished in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled && finished)
                }
            }
        }
    }

}

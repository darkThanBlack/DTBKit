//
//  SideBarAnimation.swift
//  DTBKit
//
//  Created by moonShadow on 2026/9/8
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {

    /// 侧边栏转场代理：负责提供 presentation controller 与 present/dismiss 动画。
    /// 复用同一 `SideBarAnimation` 实例，参考 `AlertTransitioningHandler` 模式。
    @objc(DTBSideBarTransitioningHandler)
    public final class SideBarTransitioningHandler: NSObject, UIViewControllerTransitioningDelegate {

        /// 抽屉宽度占比（相对容器宽度），创建后不可变，保证 present / dismiss 位移一致。
        public let widthRatio: CGFloat

        private let animation: SideBarAnimation

        public init(widthRatio: CGFloat = 0.85) {
            self.widthRatio = widthRatio
            self.animation = SideBarAnimation(widthRatio: widthRatio)
            super.init()
        }

        public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            return SideBarPresentationController(presentedViewController: presented, presenting: presenting, widthRatio: widthRatio)
        }

        public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return animation.to(.present)
        }

        public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return animation.to(.dismiss)
        }
    }

    /// 侧边栏展示控制器：负责遮罩 + 点击遮罩关闭 + 抽屉宽度。
    @objc(DTBSideBarPresentationController)
    public final class SideBarPresentationController: UIPresentationController {

        /// 抽屉宽度占比（相对容器宽度），由 handler 在 init 时注入。
        private let widthRatio: CGFloat

        init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, widthRatio: CGFloat) {
            self.widthRatio = widthRatio
            super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        }

        private lazy var scrimView: UIView = {
            let v = UIView()
            v.backgroundColor = UIColor.dtb.create("scrim")
            v.alpha = 0
            let tap = UITapGestureRecognizer(target: self, action: #selector(scrimTapped))
            v.addGestureRecognizer(tap)
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
            guard let containerView else { return .zero }
            let width = containerView.bounds.width * widthRatio
            return CGRect(x: 0, y: 0, width: width, height: containerView.bounds.height)
        }

        @objc private func scrimTapped() {
            presentedViewController.dismiss(animated: true)
        }
    }

    /// 侧边栏转场动画：抽屉从左侧滑入 / 滑出。
    @objc(DTBSideBarAnimation)
    public final class SideBarAnimation: NSObject, UIViewControllerAnimatedTransitioning {

        public enum Kind {
            case present
            case dismiss
        }

        /// 抽屉宽度占比（相对容器宽度），创建后不可变，保证 present / dismiss 位移一致。
        private let widthRatio: CGFloat

        private var kind: Kind?

        init(widthRatio: CGFloat) {
            self.widthRatio = widthRatio
            super.init()
        }

        public func to(_ kind: Kind) -> Self {
            self.kind = kind
            return self
        }

        public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.3
        }

        public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let container = transitionContext.containerView
            let width = container.bounds.width * widthRatio

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
                toView.frame = CGRect(x: -width, y: 0, width: width, height: container.bounds.height)
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    toView.frame.origin.x = 0
                }) { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled && finished)
                }

            case .dismiss:
                guard let fromView = transitionContext.view(forKey: .from) else {
                    transitionContext.completeTransition(false)
                    return
                }
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    fromView.frame.origin.x = -width
                }) { finished in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled && finished)
                }
            }
        }
    }

}

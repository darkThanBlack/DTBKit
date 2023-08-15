//
//  SimpleAlertAnimation.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/15
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// Simple alert controller transition handler
public class AlertAnimationHandler: NSObject, UIViewControllerTransitioningDelegate {
    
    ///
    public enum Types {
        /// present / dismiss on screen bottom
        case present
        /// present / dismiss on screen center
        case center
    }
    
    public let type: Types
    
    public init(type: Types = .present) {
        self.type = type
        super.init()
    }
    
    private let animation = AlertAnimation()
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch type {
        case .present:
            return animation.to(.present)
        case .center:
            return animation.to(.centerShow)
        }
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch type {
        case .present:
            return animation.to(.dismiss)
        case .center:
            return animation.to(.centerHide)
        }
    }
}

/// Simple alert transition animate
public class AlertAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    public enum Types {
        case none
        case present, dismiss
        case centerShow, centerHide
    }
    
    ///
    private var type: Types = .none
    
    /// Ensure mask view is same object
    func to(_ type: Types) -> AlertAnimation {
        self.type = type
        return self
    }
    
    /// no safearea here
    public var scSize = UIScreen.main.bounds.size
    
    //MARK: - UIViewControllerAnimatedTransitioning
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .none:
            done(with: transitionContext)
        case .present:
            presentTransition(using: transitionContext)
        case .dismiss:
            dismissTransition(using: transitionContext)
        case .centerShow:
            centerShowTransition(using: transitionContext)
        case .centerHide:
            centerHideTransition(using: transitionContext)
        }
    }
    
    private func done(with context: UIViewControllerContextTransitioning) {
        context.completeTransition(!context.transitionWasCancelled)
    }
    
    ///
    private func presentTransition(using context: UIViewControllerContextTransitioning) {
        guard let toView = context.view(forKey: .to) else {
            done(with: context)
            return
        }
        let container = context.containerView
        
        container.addSubview(backgroundView)
        container.addSubview(toView)
        
        backgroundView.alpha = 0
        toView.frame = CGRect(x: 0, y: scSize.height, width: scSize.width, height: scSize.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0.35
            toView.frame = CGRect(origin: .zero, size: self.scSize)
        }) { _ in
            self.done(with: context)
        }
    }
    
    ///
    private func dismissTransition(using context: UIViewControllerContextTransitioning) {
        guard let fromView = context.view(forKey: .from) else {
            self.done(with: context)
            return
        }
        // let container = context.containerView
        
        backgroundView.alpha = 0.35
        fromView.frame = CGRect(origin: .zero, size: self.scSize)
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
            fromView.frame = CGRect(x: 0, y: self.scSize.height, width: self.scSize.width, height: self.scSize.height)
        }) { _ in
            self.backgroundView.removeFromSuperview()
            fromView.removeFromSuperview()
            
            self.done(with: context)
        }
    }
    
    ///
    private func centerShowTransition(using context: UIViewControllerContextTransitioning) {
        guard let toView = context.view(forKey: .to) else {
            done(with: context)
            return
        }
        let container = context.containerView
        
        container.addSubview(backgroundView)
        container.addSubview(toView)
        
        backgroundView.alpha = 0
        toView.alpha = 0.0
        toView.center = CGPoint(x: scSize.width / 2.0, y: scSize.height / 2.0)
        toView.bounds = .zero
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0.35
            toView.alpha = 1.0
            toView.bounds = CGRect(origin: .zero, size: self.scSize)
        }) { _ in
            self.done(with: context)
        }
    }
    
    ///
    private func centerHideTransition(using context: UIViewControllerContextTransitioning) {
        guard let fromView = context.view(forKey: .from) else {
            self.done(with: context)
            return
        }
        // let container = context.containerView
        
        self.backgroundView.alpha = 0.35
        fromView.alpha = 1.0
        fromView.center = CGPoint(x: scSize.width / 2.0, y: scSize.height / 2.0)
        fromView.bounds = CGRect(origin: .zero, size: self.scSize)
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0
            fromView.alpha = 0.0
            fromView.bounds = .zero
        }) { _ in
            self.backgroundView.removeFromSuperview()
            fromView.removeFromSuperview()
            
            self.done(with: context)
        }
    }
    
    /// Gray mask
    private lazy var backgroundView: UIView = {
        let backgrounds = UIView()
        backgrounds.backgroundColor = .black
        backgrounds.frame = CGRect(origin: .zero, size: scSize)
        backgrounds.alpha = 0
        return backgrounds
    }()
}

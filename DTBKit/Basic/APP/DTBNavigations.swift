//
//  DTBNavigations.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension Navigate {
    
    /// Current controller in stack
    public static func topMost(_ root: UIViewController? = nil) -> UIViewController? {
        return (root ?? App.keyWindow()?.rootViewController)?.dtb.topMost()
    }
    
    /// Simply pop / dismiss / remove
    @discardableResult
    public static func popAnyway(_ root: UIViewController? = nil, animated: Bool = true) -> Bool {
        return Navigate.topMost(root)?.dtb.popAnyway(animated: animated) ?? false
    }
}

extension DTBKitWrapper where Base: UIViewController {
    
    /// Current controller in stack
    public func topMost() -> UIViewController? {
        ///
        func recursion(_ vc: UIViewController?) -> UIViewController? {
            if let nav = vc as? UINavigationController {
                return recursion(nav.visibleViewController)
            }
            if let tab = vc as? UITabBarController {
                return recursion(tab.selectedViewController)
            }
            if let presented = vc?.presentedViewController {
                return recursion(presented)
            }
            return vc
        }
        return recursion(me)
    }

    /// Simply pop / dismiss / remove
    @discardableResult
    public func popAnyway(animated: Bool = true) -> Bool {
        if let nav = me.navigationController ?? (me as? UINavigationController) {
            nav.popViewController(animated: animated)
            return true
        }
        if me.presentingViewController != nil {
            me.dismiss(animated: animated)
            return true
        }
        if me.parent != nil {
            me.willMove(toParent: nil)
            me.view.removeFromSuperview()
            me.removeFromParent()
            return true
        }
        return false
    }
}

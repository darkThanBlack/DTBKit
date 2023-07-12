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

extension Navigate {
    
    /// Current controller in stack
    public static func topMost() -> UIViewController? {
        return App.keyWindow()?.rootViewController?.dtb.topMost()
    }
    
    /// Simply pop / dismiss / remove
    @discardableResult
    public static func popAnyway(animated: Bool = true) -> Bool {
        return App.keyWindow()?.rootViewController?.dtb.popAnyway(animated: animated) ?? false
    }
}

extension DTBKit.DTBKitWrapper where Base: UIViewController {

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
        return recursion(mySelf)
    }

    /// Simply pop / dismiss / remove
    @discardableResult
    public func popAnyway(animated: Bool = true) -> Bool {
        if let nav = mySelf.navigationController ?? (mySelf as? UINavigationController) {
            nav.popViewController(animated: animated)
            return true
        }
        if mySelf.presentingViewController != nil {
            mySelf.dismiss(animated: animated)
            return true
        }
        if mySelf.parent != nil {
            mySelf.willMove(toParent: nil)
            mySelf.view.removeFromSuperview()
            mySelf.removeFromParent()
            return true
        }
        return false
    }
}

//
//  UIViewController+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/10/25
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
extension DTBKitStaticWrapper where T: UIViewController {
    
    /// Recursion get the top most view controller.
    ///
    /// 递归取栈顶。
    public func topMost() -> UIViewController? {
        return UIWindow.dtb.keyWindow()?.value.rootViewController?.dtb.topMost?.value
    }
    
    /// Try pop / dismiss / remove top most view controller
    ///
    /// 依次尝试各种方法去移除 ``topMost``，在诸如 ``WKWebView`` 内部的场景下可能会用到。
    ///
    /// - Returns: success == true
    @discardableResult
    public func popAnyway(animated: Bool = true) -> Bool {
        guard let controller = topMost() else {
            return false
        }
        // pop
        if let nav = controller.navigationController ?? (controller as? UINavigationController) {
            nav.popViewController(animated: animated)
            return true
        }
        // dismiss
        if controller.presentingViewController != nil {
            controller.dismiss(animated: animated)
            return true
        }
        // remove child
        if controller.parent != nil {
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
            return true
        }
        return false
    }
}

///
extension DTBKitWrapper where Base == UIViewController {
    
    /// Recursion get the top most view controller.
    ///
    /// 递归取栈顶。
    ///
    /// [refer](https://github.com/devxoul/URLNavigator)
    public var topMost: DTBKitWrapper<UIViewController>? {
        // presented view controller
        if let presentedViewController = me.presentedViewController {
            return presentedViewController.dtb.topMost
        }
        // UITabBarController
        if let tabBarController = me as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return selectedViewController.dtb.topMost
        }
        // UINavigationController
        if let navigationController = me as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return visibleViewController.dtb.topMost
        }
        // UIPageController
        if let pageViewController = me as? UIPageViewController,
           pageViewController.viewControllers?.count == 1 {
            return pageViewController.viewControllers?.first?.dtb.topMost
        }
        // child view controller
        for subview in me.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return childViewController.dtb.topMost
            }
        }
        return self
    }
}

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
extension StaticWrapper where T: UIViewController {
    
    /// Recursion get the top most view controller.
    ///
    /// 递归取栈顶。
    public func topMost() -> UIViewController? {
        return UIWindow.dtb.keyWindow()?.rootViewController?.dtb.topMost?.value
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
extension Wrapper where Base == UIViewController {
    
    /// Recursion get the top most view controller.
    ///
    /// 递归取栈顶。
    ///
    /// [refer](https://github.com/devxoul/URLNavigator)
    public var topMost: Wrapper<UIViewController>? {
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
    
    /// Try pop / dismiss / remove top most view controller
    ///
    /// 依次尝试各种方法去移除当前控制器；常见业务：``WKWebView``
    ///
    /// - Returns: success == true
    @discardableResult
    public func popAnyway(animated: Bool = true) -> Bool {
        // me.pop
        if let nav = me as? UINavigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: animated)
            return true
        }
        // pop
        if let nav = me.navigationController {
            if nav.viewControllers.count > 1 {
                nav.popViewController(animated: animated)
                return true
            }
            if nav.presentedViewController != nil {
                nav.dismiss(animated: animated)
                return true
            }
        }
        // dismiss
        if me.presentingViewController != nil {
            me.dismiss(animated: animated)
            return true
        }
        // child
        if me.parent != nil {
            // do nth.
        }
        return false
    }
    
    /// Try pop / dismiss / remove to window root view controller
    ///
    /// 递归移除当前控制器, 返回到 window.rootViewController
    ///
    /// - Returns: success == false
    @discardableResult
    public func popToMainRootAnyway() -> Bool {
        // me.pop
        if let nav = me as? UINavigationController {
            if nav.viewControllers.count > 1, let root = nav.viewControllers.first {
                nav.popToRootViewController(animated: false)
                return root.dtb.popToMainRootAnyway()
            }
        }
        // pop
        if let nav = me.navigationController {
            if nav.viewControllers.count > 1, let root = nav.viewControllers.first {
                nav.popToRootViewController(animated: false)
                return root.dtb.popToMainRootAnyway()
            }
        }
        // dismiss
        if let presenting = me.presentingViewController {
            me.dismiss(animated: false)
            return presenting.dtb.popToMainRootAnyway()
        }
        // child / tabbar / page
        if let parent = me.parent {
            return parent.dtb.popToMainRootAnyway()
        }
        return false
    }

}

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

extension DTBKitStaticWrapper where T: UIViewController {
    
    
    public func topMost() -> DTBKitWrapper<UIViewController>? {
        return DTB.keyWindow()?.rootViewController?.dtb.topMost
    }
}

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
            return pageViewController.viewControllers?.first?.dtb.topMost()
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

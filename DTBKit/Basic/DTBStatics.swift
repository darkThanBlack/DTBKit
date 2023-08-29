//
//  SystemAdapter.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {
    
    /// Current scene in general
    ///
    /// 取 ``scene``，注定无法准确，用前请读最佳实践。
    ///
    /// [best practices](https://darkthanblack.github.io/blogs/04-bp-keywindow)
    /// [refer](https://stackoverflow.com/questions/57134259)
    @available(iOS 13.0, *)
    public static func scene() -> UIWindowScene? {
        return UIApplication
            .shared
            .connectedScenes
            .compactMap({ ($0 as? UIWindowScene) })
            .first
    }
    
    /// Current window in general
    ///
    /// 取 ``keyWindow``，注定无法准确，用前请读最佳实践。
    ///
    /// [best practices](https://darkthanblack.github.io/blogs/04-bp-keywindow)
    /// [refer](https://stackoverflow.com/questions/57134259)
    public static func keyWindow() -> UIWindow? {
        
        func style3() -> UIWindow? {
            if #available(iOS 15.0, *) {
                return scene()?.keyWindow
            }
            return nil
        }
        
        func style2() -> UIWindow? {
            if #available(iOS 13.0, *) {
                return scene()?
                    .windows
                    .first(where: { $0.isKeyWindow })
            }
            return nil
        }
        
        func style1() -> UIWindow? {
            return UIApplication.shared.keyWindow
        }
        return style3() ?? style2() ?? style1()
    }
    
    /// Top most view controller in general
    ///
    /// 取栈顶。
    ///
    /// [refer](https://github.com/devxoul/URLNavigator)
    public static var topMost: UIViewController? {
        return topMost(of: keyWindow()?.rootViewController)
    }
    
    /// Recursion get the top most view controller
    ///
    /// 递归取栈顶。
    ///
    /// [refer](https://github.com/devxoul/URLNavigator)
    public static func topMost(of controller: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = controller?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }
        // UITabBarController
        if let tabBarController = controller as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }
        // UINavigationController
        if let navigationController = controller as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }
        // UIPageController
        if let pageViewController = controller as? UIPageViewController,
           pageViewController.viewControllers?.count == 1 {
            return self.topMost(of: pageViewController.viewControllers?.first)
        }
        // child view controller
        for subview in controller?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }
        return controller
    }
    
    /// Try pop / dismiss / remove top most view controller
    ///
    /// 依次尝试各种方法去移除 ``topMost``，在诸如 ``WKWebView`` 内部的场景下可能会用到。
    ///
    /// - Returns: success == true
    @discardableResult
    public static func popAnyway(animated: Bool = true) -> Bool {
        guard let controller = topMost else {
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
        // child remove
        if controller.parent != nil {
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
            return true
        }
        return false
    }
    
    /// Status bar height
    ///
    /// * I suggest using "safe area" instead of "const px" whenever possible.
    /// * Anyway, do *NOT* use it before ``window.makeKeyAndVisable``
    ///
    /// * 仅用于老代码兼容，新代码不应再使用
    /// * 同时注意不要在 ``window.makeKeyAndVisable`` 之前，一般也就是首页布局中调用
    ///
    /// [best practices](https://darkthanblack.github.io/blogs/05-bp-statusbar)
    public static var statusBarHeight: CGFloat {
        get {
            
            func style3() -> CGFloat? {
                if #available(iOS 13.0, *) {
                    return scene()?.statusBarManager?.statusBarFrame.size.height
                }
                return nil
            }
            
            func style2() -> CGFloat? {
                if #available(iOS 11.0, *) {
                    return keyWindow()?.safeAreaInsets.top
                }
                return nil
            }
            
            func style1() -> CGFloat {
                return UIApplication.shared.statusBarFrame.size.height
            }
            return style3() ?? style2() ?? style1()
        }
        set {}
    }
}

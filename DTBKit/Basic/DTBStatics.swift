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
        
        func step1() -> UIWindow? {
            if #available(iOS 15.0, *) {
                return scene()?.keyWindow
            }
            return nil
        }
        
        func step2() -> UIWindow? {
            if #available(iOS 13.0, *) {
                return scene()?
                    .windows
                    .first(where: { $0.isKeyWindow })
            }
            return nil
        }
        
        func step3() -> UIWindow? {
            return UIApplication.shared.keyWindow
        }
        return step1() ?? step2() ?? step3()
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
        if let nav = controller.navigationController ?? (controller as? UINavigationController) {
            nav.popViewController(animated: animated)
            return true
        }
        if controller.presentingViewController != nil {
            controller.dismiss(animated: animated)
            return true
        }
        if controller.parent != nil {
            controller.willMove(toParent: nil)
            controller.view.removeFromSuperview()
            controller.removeFromParent()
            return true
        }
        return false
    }
    
    /// Status bar height, do not use it in general
    ///
    /// * I suggest using "safe area" instead of "const px" whenever possible.
    /// * Anyway, do *NOT* use it before ``window.makeKeyAndVisable``
    ///
    /// Sample code with "auto layout" + "safe area" may like:
    /// ```
    ///    let father = UIView()
    ///    let son = UIView()
    ///    [father, son].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    ///    if #available(iOS 11.0, *) {
    ///        son.topAnchor.constraint(equalTo: father.safeAreaLayoutGuide.topAnchor, constant: 0.0).isActive = true
    ///    } else {
    ///        son.topAnchor.constraint(equalTo: father.topAnchor, constant: 0.0).isActive = true
    ///    }
    /// ```
    ///
    /// Sample code with "frame" + "safe area" may like:
    /// ```
    ///    if #available(iOS 11.0, *) {
    ///        son.frame.origin.x = father.safeAreaInsets.top + 8.0
    ///    } else {
    ///        son.frame.origin.x = 8.0
    ///    }
    /// ```
    public static var statusBarHeight: CGFloat {
        get {
            ///
            func oldHeight() -> CGFloat {
                let height = UIApplication.shared.statusBarFrame.size.height
                if #available(iOS 11.0, *) {
                    return keyWindow()?.safeAreaInsets.top ?? height
                } else {
                    return height
                }
            }
            
            if #available(iOS 13.0, *) {
                return scene()?.statusBarManager?.statusBarFrame.size.height ?? oldHeight()
            } else {
                return oldHeight()
            }
        }
        set {}
    }
}

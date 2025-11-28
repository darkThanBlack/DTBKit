//
//  FastNavigationController.swift
//  Example
//
//  Created by moonShadow on 2025/10/13
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

///
class NavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        isNavigationBarHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 快捷隐藏自定义的异形 tabbar
    private func setCustomTabBarHidden(_ isHidden: Bool) {
        guard let tabbarVC = tabBarController as? TabBarController else {
            return
        }
        tabbarVC.setCustomTabBarHidden(isHidden)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        setCustomTabBarHidden(true)
        super.pushViewController(viewController, animated: animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        viewControllers.forEach({ $0.hidesBottomBarWhenPushed = true })
        if viewControllers.count == 1 {
            setCustomTabBarHidden(false)
        }
        super.setViewControllers(viewControllers, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if self.viewControllers.count == 2 {
            setCustomTabBarHidden(false)
        }
        return super.popViewController(animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        setCustomTabBarHidden(false)
        return super.popToRootViewController(animated: animated)
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
}

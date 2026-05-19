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

extension DTB {
    
    /// Work with CustomTabBarController
    @objc(DTBCustomNavigationController)
    open class CustomNavigationController: UINavigationController {
        
        public override init(rootViewController: UIViewController) {
            super.init(rootViewController: rootViewController)
            
            isNavigationBarHidden = true
        }
        
        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /// StatusBar
        public override var childForStatusBarStyle: UIViewController? {
            return topViewController
        }
        
        /// StatusBar
        public override var childForStatusBarHidden: UIViewController? {
            return topViewController
        }
        
        /// 处理自定义的 tabBar
        private func setCustomTabBarHidden(_ isHidden: Bool, animated: Bool) {
            guard let tabbarVC = UIWindow.dtb.keyWindow()?.rootViewController as? DTB.CustomTabBarController else {
                DTB.console.assert()
                return
            }
            tabbarVC.setCustomTabBarHidden(isHidden, animated: animated)
        }
        
        public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            setCustomTabBarHidden(true, animated: animated)
            super.pushViewController(viewController, animated: animated)
        }
        
        public override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
            if viewControllers.count == 1 {
                setCustomTabBarHidden(false, animated: animated)
            }
            super.setViewControllers(viewControllers, animated: animated)
        }
        
        public override func popViewController(animated: Bool) -> UIViewController? {
            if self.viewControllers.count == 2 {
                setCustomTabBarHidden(false, animated: animated)
            }
            return super.popViewController(animated: animated)
        }
        
        public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
            setCustomTabBarHidden(false, animated: animated)
            return super.popToRootViewController(animated: animated)
        }
        
    }

}


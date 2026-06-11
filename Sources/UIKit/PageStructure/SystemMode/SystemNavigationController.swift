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
    
    /// Work with SystemTabBarController
    @objc(DTBSystemNavigationController)
    open class SystemNavigationController: UINavigationController {
        
        public override init(rootViewController: UIViewController) {
            super.init(rootViewController: rootViewController)
            
            modalPresentationStyle = .fullScreen
            isNavigationBarHidden = true
        }
        
        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        /// Work with rootViewController
        public override var hidesBottomBarWhenPushed: Bool {
            set {
                viewControllers.first?.hidesBottomBarWhenPushed = newValue
            }
            get {
                return viewControllers.first?.hidesBottomBarWhenPushed ?? false
            }
        }
        
        /// StatusBar
        public override var childForStatusBarStyle: UIViewController? {
            return topViewController
        }
        
        /// StatusBar
        public override var childForStatusBarHidden: UIViewController? {
            return topViewController
        }
        
        public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            // Work with rootViewController
            viewController.hidesBottomBarWhenPushed = true
            super.pushViewController(viewController, animated: animated)
        }
        
        public override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
            // Work with rootViewController
            viewControllers.forEach({ $0.hidesBottomBarWhenPushed = true })
            viewControllers.first?.hidesBottomBarWhenPushed = false
            super.setViewControllers(viewControllers, animated: animated)
        }
        
        public override func popViewController(animated: Bool) -> UIViewController? {
            return super.popViewController(animated: animated)
        }
        
        public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
            return super.popToRootViewController(animated: animated)
        }
        
    }

}


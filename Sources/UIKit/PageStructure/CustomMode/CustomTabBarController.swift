//
//  TabBarController.swift
//  Example
//
//  Created by moonShadow on 2025/9/26
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {
    
    ///
    public protocol TabBarData {
        
        var backgroundColor: UIColor { get }
        
        var unSelectTintColor: UIColor { get }
        
        var selectedTintColor: UIColor { get }
    }
    
    ///
    public protocol TabBarItemData {
        
        var rootViewController: UIViewController { get }
        
        var title: String? { get }
        
        var image: UIImage?  { get }
        
        var selectedImage: UIImage?  { get }
        
        var font: UIFont?  { get }
    }
    
    ///
    public protocol CustomTabBarProvider: UIView {
        
        /// 在 vc 内的布局
        func setupWhenViewDidLoad(_ controller: DTB.CustomTabBarController)
        
        /// 显隐控制
        func setCustomTabBarHidden(_ controller: DTB.CustomTabBarController, isHidden: Bool, animated: Bool)
        
        /// 按钮 UI
        func setSelectItem(at index: Int)
        
        /// 用户事件
        func userDidSelectItem(_ handler: ((_ index: Int) -> ())?)
        
        func updateConfig(_ data: TabBarData)
        
        func updateItems(_ items: [TabBarItemData])
    }
    
    /// Use custom (TabBar + TabBarItem + navigation)
    ///
    /// * This is an sample for how to:
    ///   * setup custom view by yourself
    ///   * control hidden by yourself
    @objc(DTBCustomTabBarController)
    open class CustomTabBarController: UITabBarController {
        
        ///
        public let customTabBar: CustomTabBarProvider
        
        public init(customTabBar: CustomTabBarProvider) {
            self.customTabBar = customTabBar
            super.init(nibName: nil, bundle: nil)
            
            customTabBar.userDidSelectItem { [weak self] index in
                self?.selectedIndex = index
            }
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override var selectedIndex: Int {
            didSet {
                customTabBar.setSelectItem(at: selectedIndex)
            }
        }
        
        /// StatusBar
        public override var childForStatusBarHidden: UIViewController? {
            return selectedViewController
        }
        
        /// StatusBar
        public override var childForStatusBarStyle: UIViewController? {
            return selectedViewController
        }
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            tabBar.isHidden = true
            
            customTabBar.setupWhenViewDidLoad(self)
        }
        
        /// Replacement for system hidden | 自行处理显隐
        public func setCustomTabBarHidden(_ isHidden: Bool, animated: Bool) {
            self.customTabBar.setCustomTabBarHidden(self, isHidden: isHidden, animated: animated)
        }
        
        /// 传递给自定义的 TabBar
        public func setupTabBar(_ data: TabBarData) {
            self.customTabBar.updateConfig(data)
        }
        
        ///
        public func setupTabBarItems(_ items: [TabBarItemData]) {
            self.customTabBar.updateItems(items)
            self.viewControllers = items.compactMap({ getNavigationController(by: $0) })
        }
        
        ///
        private func getNavigationController(by item: TabBarItemData) -> UINavigationController {
            let nav = CustomNavigationController(rootViewController: item.rootViewController)
            // Always hide original bottom bar
            item.rootViewController.hidesBottomBarWhenPushed = true
            return nav
        }
        
    }

}

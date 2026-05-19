//
//  SystemTabBarController.swift
//  Ring
//
//  Created by moonShadow on 2026/5/18
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// Use original (UITabBar + UITabBarItem) + custom (navigation)
    ///
    /// * This is an sample for how to:
    ///   * UITabBar iOS version adapt
    ///   * hidden bottomBar
    @objc(DTBSystemTabBarController)
    open class SystemTabBarController: UITabBarController {
        
        public override var childForStatusBarHidden: UIViewController? {
            return selectedViewController
        }
        
        public override var childForStatusBarStyle: UIViewController? {
            return selectedViewController
        }
        
        /// 处理原生 TabBar 常见问题
        public func setupTabBar(_ data: TabBarDatas) {
            tabBar.isHidden = false
            
            // < iOS 13.0
            tabBar.isTranslucent = false
            tabBar.backgroundColor = data.backgroundColor
            tabBar.tintColor = data.selectedTintColor
            tabBar.unselectedItemTintColor = data.unSelectTintColor
            
            // [refer](https://www.jianshu.com/p/9ac1f29b54ba)
            // iOS 13
            if #available(iOS 13.0, *) {
                let appear = {
                    let appear = UITabBarAppearance()
                    appear.stackedLayoutAppearance = {
                        let itemAppear = UITabBarItemAppearance()
                        itemAppear.normal.titleTextAttributes = .dtb.create.foregroundColor(data.unSelectTintColor).value
                        itemAppear.selected.titleTextAttributes = .dtb.create.foregroundColor(data.selectedTintColor).value
                        return itemAppear
                    }()
                    
                    appear.configureWithOpaqueBackground()
                    appear.backgroundColor = data.backgroundColor
                    
                    // this removes the top line of the tabBar
//                    appear.backgroundImage = UIImage()
                    // this changes the UI backdrop view of tabBar to transparent
//                    appear.shadowImage = UIImage()
                    appear.shadowColor = .clear
                    return appear
                }()
                
                tabBar.standardAppearance = appear
                // iOS 15
                if #available(iOS 15.0, *) {
                    tabBar.scrollEdgeAppearance = appear
                }
            } else {
                // < iOS 13
                // this removes the top line of the tabBar
                tabBar.shadowImage = UIImage()
                // this changes the UI backdrop view of tabBar to transparent
                tabBar.backgroundImage = UIImage()
            }
        }
        
        ///
        public func setupTabBarItems(_ items: [TabBarItemDatas]) {
            self.viewControllers = items.compactMap({ getNavigationController(by: $0) })
        }
        
        ///
        private func getNavigationController(by item: TabBarItemDatas) -> UINavigationController {
            let nav = SystemNavigationController(rootViewController: item.rootViewController)
            // Work with nav
            item.rootViewController.hidesBottomBarWhenPushed = false
            nav.tabBarItem = getBarItem(by: item)
            return nav
        }
        
        /// 创建系统 item
        private func getBarItem(by item: TabBarItemDatas) -> UITabBarItem {
            let tabBarItem = UITabBarItem(
                title: item.title,
                image: item.image?.withRenderingMode(.alwaysTemplate),
                selectedImage: item.selectedImage?.withRenderingMode(.alwaysTemplate)
            )
            tabBarItem.setTitleTextAttributes(
                .dtb.create
                    .foregroundColor(tabBar.unselectedItemTintColor)
                    .font(item.font)
                    .value,
                for: .normal
            )
            tabBarItem.setTitleTextAttributes(
                .dtb.create
                    .foregroundColor(tabBar.tintColor)
                    .font(item.font)
                    .value,
                for: .selected
            )
            return tabBarItem
        }
        
    }
    
}

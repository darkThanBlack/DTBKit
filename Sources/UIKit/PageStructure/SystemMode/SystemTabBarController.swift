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
        public func setupTabBar(_ data: TabBarData) {
            tabBar.isHidden = false
            
            tabBar.isTranslucent = false
            tabBar.backgroundColor = data.backgroundColor
            tabBar.tintColor = data.selectedTintColor
            
            // [ISSUE](https://developer.apple.com/forums/thread/803940)
            //
            // 截止目前(2026.07) 官方依然不再允许修改普通 item 的样式,
            // unselectedItemTintColor 和 itemAppear.normal 均失效
            tabBar.unselectedItemTintColor = data.unSelectTintColor
            
            // 去除顶部黑线，< iOS 13 时生效
            // this changes the UI backdrop view of tabBar to transparent
            tabBar.backgroundImage = UIImage()
            // this removes the top line of the tabBar
            tabBar.shadowImage = UIImage()
            
            // [refer](https://www.jianshu.com/p/9ac1f29b54ba)
            // >= iOS 13，新增 Appearance API
            if #available(iOS 13.0, *) {
                let appear = {
                    let appear = UITabBarAppearance()
                    // call first
                    appear.configureWithOpaqueBackground()
                    appear.backgroundColor = data.backgroundColor
                    
                    // 去除顶部黑线
                    // this removes the top line of the tabBar
                    appear.backgroundImage = UIImage()
                    // this changes the UI backdrop view of tabBar to transparent
                    appear.shadowImage = UIImage()
                    appear.shadowColor = .clear
                    
                    appear.stackedLayoutAppearance = {
                        let itemAppear = UITabBarItemAppearance()
                        itemAppear.normal.titleTextAttributes = .dtb.create.foregroundColor(data.unSelectTintColor).value
                        itemAppear.normal.iconColor = data.unSelectTintColor
                        itemAppear.selected.titleTextAttributes = .dtb.create.foregroundColor(data.selectedTintColor).value
                        itemAppear.selected.iconColor = data.selectedTintColor
                        return itemAppear
                    }()
                    
                    return appear
                }()
                
                tabBar.standardAppearance = appear
                if #available(iOS 15.0, *) {
                    tabBar.scrollEdgeAppearance = appear
                }
            }
        }
        
        ///
        public func setupTabBarItems(_ items: [TabBarItemData]) {
            self.viewControllers = items.compactMap({ getNavigationController(by: $0) })
        }
        
        ///
        private func getNavigationController(by item: TabBarItemData) -> UINavigationController {
            let nav = SystemNavigationController(rootViewController: item.rootViewController)
            // Work with nav
            item.rootViewController.hidesBottomBarWhenPushed = false
            nav.tabBarItem = getBarItem(by: item)
            return nav
        }
        
        /// 创建系统 item
        private func getBarItem(by item: TabBarItemData) -> UITabBarItem {
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

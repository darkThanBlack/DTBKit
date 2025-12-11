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

///
public class TabBarController: UITabBarController {
    
    struct Colors {
        let backgroundColor = UIColor.dtb.create("tab_bar_background")
        let unSelectColor = UIColor.dtb.create("tab_bar_unselect")
        let selectedColor = UIColor.dtb.create("theme")
    }
    
    private let color = Colors()
    
    private lazy var customTabBar = CustomTabBar(effect: UIBlurEffect(style: .dark))
    
    public func setCustomTabBarHidden(_ isHidden: Bool) {
        customTabBar.isHidden = isHidden
    }
    
    public override var childForStatusBarHidden: UIViewController? {
        return selectedViewController
    }
    
    public override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var selectedIndex: Int {
        didSet {
            customTabBar.selectItem(at: selectedIndex)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        setupSystemTabBar()
        setupViewControllers(true)
        // setupCustomTabBar()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if need login...
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 使用原生 TabBar
    private func setupSystemTabBar() {
        tabBar.isHidden = false
        
        // < iOS 13.0
        tabBar.isTranslucent = false
        tabBar.backgroundColor = color.backgroundColor
        tabBar.tintColor = color.selectedColor
        tabBar.unselectedItemTintColor = color.unSelectColor
        
        // [refer](https://www.jianshu.com/p/9ac1f29b54ba)
        // FIX: iOS 13
        if #available(iOS 13.0, *) {
            let appear = {
                let appear = UITabBarAppearance()
                appear.stackedLayoutAppearance = {
                    let itemAppear = UITabBarItemAppearance()
                    itemAppear.normal.titleTextAttributes = .dtb.create.foregroundColor(color.unSelectColor).value
                    itemAppear.selected.titleTextAttributes = .dtb.create.foregroundColor(color.selectedColor).value
                    return itemAppear
                }()
                
                appear.configureWithOpaqueBackground()
                appear.backgroundColor = color.backgroundColor
                
                // this removes the top line of the tabBar
                appear.backgroundImage = UIImage()
                // this changes the UI backdrop view of tabBar to transparent
                appear.shadowImage = UIImage()
                appear.shadowColor = .clear
                return appear
            }()
            
            tabBar.standardAppearance = appear
            // FIX: iOS 15
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
    
    /// 使用自定义 TabBar
    private func setupCustomTabBar() {
        tabBar.isHidden = true
        
        view.addSubview(customTabBar)
        
        customTabBar.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-0.0)
            make.width.equalTo(200.0.dtb.hf())
            make.height.equalTo(56.0)
        }
        
        // 设置选中回调
        customTabBar.onItemSelected = { [weak self] index in
            self?.selectedIndex = index
        }
        
        // 设置初始选中状态
        customTabBar.selectItem(at: selectedIndex)
    }
    
    private func setupViewControllers(_ useSystem: Bool) {
        
        func createControllers() -> [UIViewController] {
            
            /// 创建导航控制器
            func navigationController(root: UIViewController, title: String, image: String, selectedImage: String) -> UINavigationController {
                let nav = NavigationController(rootViewController: root)
                
                nav.tabBarItem = UITabBarItem(
                    title: title,
                    image: UIImage(named: image)?.withRenderingMode(.alwaysTemplate),
                    selectedImage: UIImage(named: selectedImage)?.withRenderingMode(.alwaysTemplate)
                )
                
                nav.tabBarItem.setTitleTextAttributes([
                    .foregroundColor: color.unSelectColor,
                    .font: UIFont.dtb.create("Lora", size: 10)
                ], for: .normal)
                nav.tabBarItem.setTitleTextAttributes([
                    .foregroundColor: color.selectedColor,
                    .font: UIFont.dtb.create("Lora", size: 10)
                ], for: .selected)
                return nav
            }
            
            var viewControllers: [UIViewController] = []
            
            // home
            let homeViewController = HomeViewController()
            let homeNavigationController = navigationController(
                root: homeViewController,
                title: .dtb.create("tab_home"),
                image: "tab_bar_home_unselect",
                selectedImage: "tab_bar_home_select"
            )
            homeViewController.hidesBottomBarWhenPushed = false
//            homeNavigationController.hidesBottomBarWhenPushed = false
            viewControllers.append(homeNavigationController)
            
            // mine
            let profileViewController = MineViewController()
            profileViewController.hidesBottomBarWhenPushed = false
            let profileNavigationController = navigationController(
                root: profileViewController,
                title: .dtb.create("tab_mine"),
                image: "tab_bar_mine_unselect",
                selectedImage: "tab_bar_mine_select"
            )
            profileViewController.hidesBottomBarWhenPushed = false
//            profileNavigationController.hidesBottomBarWhenPushed = false
            viewControllers.append(profileNavigationController)
            
            return viewControllers
        }
        
        viewControllers = createControllers()
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 同步自定义 TabBar 状态
        customTabBar.selectItem(at: selectedIndex)
        
        // 可以在这里处理 Tab 切换事件
        DTB.console.print("TabBar did select: \(selectedIndex)")
    }
}

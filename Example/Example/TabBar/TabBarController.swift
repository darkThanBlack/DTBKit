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

public class TabBarController: UITabBarController {

    // MARK: - Properties
    
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
//        setupCustomTabBar()
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
        
        // 保留原有的背景设置以防需要回退
        tabBar.tintColor = UIColor.dtb.create("theme")
        tabBar.isTranslucent = false
        tabBar.backgroundColor = UIColor.dtb.create("theme")
        
        // iOS 13+ 外观配置
        if #available(iOS 13.0, *) {
            let tabAppear = UITabBarAppearance()
            tabAppear.stackedLayoutAppearance = {
                let itemAppear = UITabBarItemAppearance()
                itemAppear.normal.titleTextAttributes = .dtb.create.foregroundColor(.dtb.create("text_title")).value
                itemAppear.selected.titleTextAttributes = .dtb.create.foregroundColor(.dtb.create("theme")).value
                return itemAppear
            }()
            
            tabAppear.configureWithOpaqueBackground()
            tabAppear.backgroundColor = UIColor.dtb.create("theme")

            tabAppear.backgroundImage = UIImage()
            tabAppear.shadowImage = UIImage()
            tabAppear.shadowColor = .clear

            tabBar.standardAppearance = tabAppear
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = tabBar.standardAppearance
            }
        } else {
            // < iOS 13, refer: https://www.jianshu.com/p/9ac1f29b54ba
            tabBar.shadowImage = UIImage()  // this removes the top line of the tabBar
            tabBar.backgroundImage = UIImage()  // this changes the UI backdrop view of tabBar to transparent
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
                    image: UIImage(named: image),
                    selectedImage: UIImage(named: selectedImage)
                )

                nav.tabBarItem.setTitleTextAttributes([
                    .foregroundColor: UIColor.dtb.create("theme"),
                    .font: UIFont.dtb.create("Lora", size: 10)
                ], for: .normal)
                nav.tabBarItem.setTitleTextAttributes([
                    .foregroundColor: UIColor.dtb.create("text_title"),
                    .font: UIFont.dtb.create("Lora", size: 10)
                ], for: .selected)

                return nav
            }

            var viewControllers: [UIViewController] = []

            // 首页
            let homeViewController = HomeViewController()
            
            let homeNavigationController = navigationController(
                root: homeViewController,
                title: .dtb.create("tab_home"),
                image: "home_unselect",
                selectedImage: "home_select"
            )
            
            homeViewController.hidesBottomBarWhenPushed = useSystem ? false : true
            homeNavigationController.hidesBottomBarWhenPushed = useSystem ? false : true
            
            viewControllers.append(homeNavigationController)

            let profileViewController = SettingViewController()
            profileViewController.hidesBottomBarWhenPushed = useSystem ? false : true
            
            let profileNavigationController = navigationController(
                root: profileViewController,
                title: .dtb.create("tab_setting"),
                image: "mine_unselect",
                selectedImage: "mine_select"
            )
            
            profileViewController.hidesBottomBarWhenPushed = useSystem ? false : true
            profileNavigationController.hidesBottomBarWhenPushed = useSystem ? false : true
            
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
        print("TabBar did select: \(viewController)")
    }
}

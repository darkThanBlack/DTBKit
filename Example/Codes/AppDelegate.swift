//
//  AppDelegate.swift
//  XMSport
//
//  Created by moonShadow on 2023/12/26
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

import DoKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        DoraemonManager.shareInstance().install(withPid: "73422655743e0c15bc7aff370d8485f5")
        
        DTB.SampleAppHandler.shared.prepare(with: self.window)
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // window?.makeKeyAndVisible()
        
        return true
    }
    
    private func showLoginIfNeeded() {
        guard UserManager.shared.isLogined == false else { return }
        guard let tabBarVC = window?.rootViewController as? UITabBarController else {
            return DTB.console.error()
        }
        let vc = LoginViewController()
        let nav = DTB.SystemNavigationController(rootViewController: vc)
        tabBarVC.present(nav, animated: true)
    }
    
}

extension DTB {
    
    /// 在同一个工程中展示和切换不同的框架骨骼
    public class SampleAppHandler {
        
        /// 示例: 不同骨架
        public enum Structures: String, CaseIterable {
            
            case systemTabBar
            
            case customTabBar
        }
        
        /// 示例: 不同主题
        public enum Themes: String, CaseIterable {
            
            case sport
        }
        
        public static let shared = SampleAppHandler()
        
        private init() {
            NotificationCenter.default.addObserver(self, selector: #selector(appRestartEvent), name: DTB.Notifications.appNeedRestart, object: nil)
        }
        
        private let currentStructure: Structures = .customTabBar
        
        private let currentTheme: Themes = .sport
        
        public weak var window: UIWindow?
        
        ///
        public func prepare(with window: UIWindow?) {
            self.window = window
            
            adapter()
            providers()
            parsers()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.appRestartEvent()
                
                self.window?.makeKeyAndVisible()

            }
        }
        
        /// iOS 版本适配
        private func adapter() {
            if #available(iOS 15.0, *) {
                // 避免 section header 顶部默认间距
                //
                // [refer](https://stackoverflow.com/questions/73049647)
                UITableView.appearance().sectionHeaderTopPadding = 0
                
                // 禁止预存取导致显示混乱
                //
                // [refer](https://stackoverflow.com/questions/69676109)
                UITableView.appearance().isPrefetchingEnabled = false
            }
        }
        
        /// Provider 模式允许业务自由替换某些功能实现
        ///
        /// - 例如，大部分项目本身有自己实现的 HUD，这时候可以依然保持 dtb.showHUD() 不变，只需要替换对应的 provider
        /// - 需要在业务使用之前注册好
        /// - 部分 provider 之间存在隐性依赖，例如，hud / toast 的展示需要找到 topMost; 尽管在业务使用时才会触发，最好保持注册顺序不变
        private func providers() {
            
            // --- Provider 注册示例 ---
            
            // UI Style 最优先，其他控件可能依赖于它们
            DTB.Providers.register(DTB.ColorManager.shared, key: DTB.Providers.colorKey)
            DTB.Providers.register(DTB.I18NManager.shared, key: DTB.Providers.stringKey)
            DTB.Providers.register(DTB.FontManager.shared, key: DTB.Providers.fontKey)
            DTB.Providers.register(DTB.DefaultStylesProvider.shared, key: DTB.Providers.stylesKey)
            
            // scene 主要是为了 keyWindow 的自动实现
            if #available(iOS 13.0, *) {
                DTB.Providers.register(DTB.DefaultSceneProvider(), key: DTB.Providers.sceneKey)
            }
            // 确保 topMost 方法无误，最稳妥的方法就是直接传入 window 实例
            DTB.Providers.register(DTB.DefaultWindowProvider(window), key: DTB.Providers.windowKey)
            
            // UIImage
            DTB.Providers.register(DTB.DefaultLocalImageProvider(), key: DTB.Providers.localImageKey)
            // 选型上互斥的三方库
#if canImport(Kingfisher)
            DTB.Providers.register(DTB.KFRemoteImageProvider(), key: DTB.Providers.remoteImageKey)
#elseif canImport(SDWebImage)
            DTB.Providers.register(DTB.SDRemoteImageProvider(), key: DTB.Providers.remoteImageKey)
#endif
            
            // UI 组件
            DTB.Providers.register(DTB.DefaultHUDProvider(), key: DTB.Providers.hudKey)
            DTB.Providers.register(DTB.DefaultToastProvider(), key: DTB.Providers.toastKey)
            DTB.Providers.register(DTB.DefaultAlertProvider(), key: DTB.Providers.alertKey)
            
            // 缓存
            var cacheProviders: [DTB.Providers.CacheProvider] = [
                DTB.FileCacheProvider.shared,
                DTB.URLCacheProvider(),
                DTB.WebViewCacheProvider()
            ]
#if canImport(Kingfisher)
            cacheProviders.append(DTB.KFCacheProvider())
#elseif canImport(SDWebImage)
            cacheProviders.append(DTB.SDCacheProvider())
#endif
            DTB.DiskCacheManager.shared.registerDiskProviders(cacheProviders)
            
            // --- Provider 注册结束 ---
        }
        
        /// 解析 bundle 和配置文件
        private func parsers() {
            switch currentTheme {
            case .sport:
                DTB.ThemeManager.shared.setup(bundle: .dtb.create("DTBKitSportTheme"))
            }
            
            DTB.ThemeManager.shared.reloadData()
        }
        
        /// 通过摧毁和重建 rootViewController 来实现
        @objc private func appRestartEvent() {
            UIViewController.dtb.topMost()?.dtb.popToMainRootAnyway()
            
            switch currentStructure {
            case .systemTabBar:
                window?.rootViewController = tabBarWithSystemMode()
            case .customTabBar:
                window?.rootViewController = tabBarWithCustomMode()
            }
        }
        
        private func tabBarWithSystemMode() -> UITabBarController {
            let tabVC = DTB.SystemTabBarController()
            tabVC.setupTabBarItems([
                DTB.TabBarItemModel(
                    rootViewController: HomeViewController(),
                    title: .dtb.create("tabbar.0"),
                    image: .dtb.create("tab_bar_0_unselect"),
                    selectedImage: .dtb.create("tab_bar_0_select"),
                    font: .dtb.create(11.0)
                ),
                DTB.TabBarItemModel(
                    rootViewController: MineViewController(),
                    title: .dtb.create("tabbar.1"),
                    image: .dtb.create("tab_bar_1_unselect"),
                    selectedImage: .dtb.create("tab_bar_1_select"),
                    font: .dtb.create(11.0)
                )
            ])
            return tabVC
        }
        
        private func tabBarWithCustomMode() -> UITabBarController {
            let tabVC = DTB.CustomTabBarController(customTabBar: DTB.SimpleTabBar())
            tabVC.setupTabBar(
                DTB.TabBarModel(
                    backgroundColor: .dtb.create("bg2"),
                    unSelectTintColor: .dtb.create("text2"),
                    selectedTintColor: .dtb.create("theme")
                )
            )
            tabVC.setupTabBarItems([
                DTB.TabBarItemModel(
                    rootViewController: HomeViewController(),
                    title: .dtb.create("tabbar.0"),
                    image: .dtb.create("tab_bar_0_unselect"),
                    selectedImage: .dtb.create("tab_bar_0_select"),
                    font: .dtb.create(11.0)
                ),
                DTB.TabBarItemModel(
                    rootViewController: MineViewController(),
                    title: .dtb.create("tabbar.1"),
                    image: .dtb.create("tab_bar_1_unselect"),
                    selectedImage: .dtb.create("tab_bar_1_select"),
                    font: .dtb.create(11.0)
                )
            ])
            return tabVC
        }
        
    }
    
}

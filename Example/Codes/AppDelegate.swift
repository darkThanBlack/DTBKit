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
        
        // --- Provider 注册示例 ---
        // 很明显大部分功能需要在业务初始化之前创建
        
        // scene 主要是为了 keyWindow 的自动实现
        if #available(iOS 13.0, *) {
            DTB.Providers.register(DTB.DefaultSceneProvider(), key: DTB.Providers.sceneKey)
        }
        // 确保 topMost 方法无误，最稳妥的方法就是传入 window 实例
        DTB.Providers.register(DTB.DefaultWindowProvider(window), key: DTB.Providers.windowKey)
        
        // 如果需要国际化 / 自定义主题
        DTB.Providers.register(DTB.ColorManager.shared, key: DTB.Providers.colorKey)
        DTB.Providers.register(DTB.I18NManager.shared, key: DTB.Providers.stringKey)
        DTB.Providers.register(DTB.FontManager.shared, key: DTB.Providers.fontKey)
        DTB.Providers.register(DTB.TextStyleManager.shared, key: DTB.Providers.textStyleKey)
        
        // UIImage
        DTB.Providers.register(DTB.DefaultLocalImageProvider(), key: DTB.Providers.localImageKey)
#if canImport(Kingfisher)
        DTB.Providers.register(DTB.KFRemoteImageProvider(), key: DTB.Providers.remoteImageKey)
#elseif canImport(SDWebImage)
        DTB.Providers.register(DTB.SDRemoteImageProvider(), key: DTB.Providers.remoteImageKey)
#endif
        
        // UI 组件
        DTB.Providers.register(DTB.DefaultHUDProvider(), key: DTB.Providers.hudKey)
        DTB.Providers.register(DTB.DefaultToastProvider(), key: DTB.Providers.toastKey)
        DTB.Providers.register(DTB.DefaultAlertProvider(), key: DTB.Providers.alertKey)
        
        // Style
        DTB.Providers.register(DTB.DefaultShapeStyleProvider(), key: DTB.Providers.shapeStyleKey)
        DTB.Providers.register(DTB.DefaultGradientStyleProvider(), key: DTB.Providers.gradientStyleKey)
        DTB.Providers.register(DTB.DefaultButtonStyleProvider(), key: DTB.Providers.buttonStyleKey)
        
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
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        adapter()
        
        let tabVC = DTB.SystemTabBarController()
        //        let tabVC = DTB.CustomTabBarController(customTabBar: DTB.SimpleTabBar())
        tabVC.setupTabBar(
            DTB.TabBarModel(
                backgroundColor: .dtb.create("bg2"),
                unSelectTintColor: .dtb.create("text2"),
                selectedTintColor: .dtb.create("theme")
            )
        )
        tabVC.setupTabBarItems([
            DTB.TabBarItemModel(
                rootViewController: MapViewController(),
                title: .dtb.create("map"),
                image: .dtb.create("map_unselect"),
                selectedImage: .dtb.create("map_select"),
                font: .dtb.create(11.0)
            ),
            DTB.TabBarItemModel(
                rootViewController: TouristListViewController(),
                title: .dtb.create("tourist"),
                image: .dtb.create("tourist_unselect"),
                selectedImage: .dtb.create("tourist_select"),
                font: .dtb.create(11.0)
            ),
            DTB.TabBarItemModel(
                rootViewController: AlarmViewController(),
                title: .dtb.create("alarm"),
                image: .dtb.create("alarm_unselect"),
                selectedImage: .dtb.create("alarm_select"),
                font: .dtb.create(11.0)
            ),
            DTB.TabBarItemModel(
                rootViewController: MineViewController(),
                title: .dtb.create("mine"),
                image: .dtb.create("mine_unselect"),
                selectedImage: .dtb.create("mine_select"),
                font: .dtb.create(11.0)
            )
        ])
        
        window?.rootViewController = tabVC
        window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginStateChangedEvent), name: UserManager.loginStateChangedKey, object: nil)
        
        return true
    }
    
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
    
    @objc func loginStateChangedEvent() {
        guard let tabBarVC = window?.rootViewController as? UITabBarController else {
            return DTB.console.error()
        }
        UIViewController.dtb.topMost()?.dtb.popToMainRootAnyway()
        
        guard UserManager.shared.isLogined == false else { return }
        let vc = LoginViewController()
        let nav = DTB.SystemNavigationController(rootViewController: vc)
        tabBarVC.present(nav, animated: true)
    }
    
}

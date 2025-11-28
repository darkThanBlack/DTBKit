//
//  AppDelegate.swift
//  DTBKit
//
//  Created by moonShadow on 06/28/2023.
//  Copyright (c) 2023 moonShadow. All rights reserved.
//

import DTBKit

#if DEBUG
//import DoraemonKit
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // --- Provider 注册示例 ---
        
        // scene 主要是为了 keyWindow 的自动实现
        if #available(iOS 13.0, *) {
            DTB.Providers.register(DTB.DefaultSceneProvider(), key: DTB.Providers.sceneKey)
        }
        // 确保 topMost 方法无误，最稳妥的方法就是传入 window 实例
        DTB.Providers.register(DTB.DefaultWindowProvider(window), key: DTB.Providers.windowKey)
        
        // 如果需要国际化 / 自定义主题，显然需要在业务初始化之前创建
        DTB.Providers.register(DTB.ColorManager.shared, key: DTB.Providers.colorKey)
        DTB.Providers.register(DTB.I18NManager.shared, key: DTB.Providers.stringKey)
        DTB.Providers.register(DTB.FontManager.shared, key: DTB.Providers.fontKey)
        
        // view 组件同理
        DTB.Providers.register(DTB.DefaultHUDProvider(), key: DTB.Providers.hudKey)
        DTB.Providers.register(DTB.DefaultToastProvider(), key: DTB.Providers.toastKey)
        DTB.Providers.register(DTB.DefaultAlertProvider(), key: DTB.Providers.alertKey)
        
        // --- Provider 注册结束 ---
        
        // 假设这是业务 vc
        let nav = UINavigationController(rootViewController: HomeViewController())
        
        window?.rootViewController = nav
        
        window?.makeKeyAndVisible()
        
        adapter()
        debugger()
        
        return true
    }
    
    private func debugger() {
#if DEBUG
        //        DoraemonManager.shareInstance().install()
#endif
    }
    
    private func adapter() {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
            UITableView.appearance().isPrefetchingEnabled = false
            // UITabBar().scrollEdgeAppearance = UITabBar().standardAppearance
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}


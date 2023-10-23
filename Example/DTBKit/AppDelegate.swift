//
//  AppDelegate.swift
//  DTBKit
//
//  Created by moonShadow on 06/28/2023.
//  Copyright (c) 2023 moonShadow. All rights reserved.
//

import UIKit

#if DEBUG
//import DoraemonKit
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let nav = UINavigationController(rootViewController: HomeViewController())
        
        window?.rootViewController = nav
        
        window?.makeKeyAndVisible()
        
        adapter()
        debugger()
        
//        print(Int64(Date().timeIntervalSince1970 * 1000))
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
//            print(Int64(Date().timeIntervalSince1970 * 1000))
//        })
        
//        let a = "".dtb.nsAttr.append(items: [(String, [NSAttributedString.Key : Any]?)])
        
        /// 检查对象引用情况
        ///
        /// a, b, c 为不同对象
        func mem_cow_01() {
            let a: [NSAttributedString.Key : Any] = [:].dtb.set.font(.systemFont(ofSize: 13)).value
            let b = a.dtb.set.foregroundColor(.white).value
            let c = b.dtb.set.font(.systemFont(ofSize: 15.0)).value
            b.dtb.set.foregroundColor(.black)
            
            print("\(a[.font]) \n \(b[.foregroundColor]) \n \(c[.font])")
        }
        
        /// 检查对象引用情况
        ///
        /// a, b, c 为同一对象
        func mem_cow_02() {
            let a = UILabel().dtb.text("a").value
            let b = a.dtb.isUserInteractionEnabled(false).value
            let c = b.dtb.text("c").value
            b.dtb.text("b")
            
            print("\(a.text) \n \(b.text) \n \(c.text)")
        }
        
        mem_cow_01()
        mem_cow_02()
        
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


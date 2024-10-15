//
//  UIWindow+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/10/26
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// See more details in ``dtbkit_adapter.md``
public protocol DTBKitAdapterForUIWindow {
    
    /// Current window in general for nonscene-based app. I recommended you override this method and get it with hard-coding.
    ///
    /// 默认实现注定无法准确；推荐您重载该方法，通过 tag 写死来获取。
    ///
    /// e.g.
    /// ```
    /// extension XMKitStaticWrapper where T: UIWindow {
    ///
    ///     public func keyWindow() -> UIWindow? {
    ///         return UIApplication.shared.windows.first(where: { $0.tag == MyApp.windowTag })
    ///     }
    /// }
    /// ```
    ///
    /// [best practices | 最佳实践](https://darkthanblack.github.io/blogs/04-bp-keywindow)
    ///
    /// [refer | 一些讨论](https://stackoverflow.com/questions/57134259)
    func keyWindow() -> UIWindow?
}

extension DTBKitAdapterForUIWindow {
    
    public func keyWindow() -> UIWindow? {
        
        @available(iOS 13.0, *)
        func getScene() -> UIWindowScene? {
            return UIApplication
                .shared
                .connectedScenes
                .compactMap({ ($0 as? UIWindowScene) })
                .first
        }
        
        func style3() -> UIWindow? {
            if #available(iOS 15.0, *) {
                return getScene()?.keyWindow
            }
            return nil
        }
        
        func style2() -> UIWindow? {
            if #available(iOS 13.0, *) {
                return getScene()?.windows.first(where: { $0.isKeyWindow })
            }
            return nil
        }
        
        func style1() -> UIWindow? {
            return UIApplication.shared.keyWindow
        }
        return style3() ?? style2() ?? style1()
    }
}

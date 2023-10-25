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

@available(iOS 13.0, *)
extension DTBKitStaticWrapper where T: UIWindowScene {
    
    /// Current scene in general.
    ///
    /// 取 ``scene``，注定无法准确，用前请读最佳实践。
    ///
    /// [best practices](https://darkthanblack.github.io/blogs/04-bp-keywindow)
    /// [refer](https://stackoverflow.com/questions/57134259)
    @available(iOS 13.0, *)
    public func current() -> DTBKitWrapper<UIWindowScene>? {
        return UIApplication
            .shared
            .connectedScenes
            .compactMap({ ($0 as? UIWindowScene) })
            .first?
            .dtb
    }
}

///
extension DTBKitStaticWrapper where T: UIWindow {
    
    /// Current window in general.
    ///
    /// 取 ``keyWindow``，注定无法准确，用前请读最佳实践。
    ///
    /// [best practices](https://darkthanblack.github.io/blogs/04-bp-keywindow)
    /// [refer](https://stackoverflow.com/questions/57134259)
    public func keyWindow() -> DTBKitWrapper<UIWindow>? {

        func style3() -> UIWindow? {
            if #available(iOS 15.0, *) {
                return UIWindowScene.dtb.current()?.value.keyWindow
            }
            return nil
        }

        func style2() -> UIWindow? {
            if #available(iOS 13.0, *) {
                return UIWindowScene.dtb.current()?.value
                    .windows
                    .first(where: { $0.isKeyWindow })
            }
            return nil
        }

        func style1() -> UIWindow? {
            return UIApplication.shared.keyWindow
        }
        return (style3() ?? style2() ?? style1())?.dtb
    }
}

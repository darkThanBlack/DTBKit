//
//  WindowProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/7/31
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

public protocol WindowProvider {
    
    func keyWindow() -> UIWindow?
}

extension StaticWrapper where T: UIWindow {
    
    /// Current window in general for nonscene-based app.
    ///
    /// 默认实现注定无法准确，用前请读最佳实践。
    ///
    /// [best practices](https://darkthanblack.github.io/blogs/04-bp-keywindow)
    /// [refer](https://stackoverflow.com/questions/57134259)
    public func keyWindow() -> UIWindow? {
        if let window = DTB.app.get(DTB.BasicInterface.windowKey)?.keyWindow() {
            return window
        }
        
        func style3() -> UIWindow? {
            if #available(iOS 15.0, *) {
                return UIWindowScene.dtb.current()?.keyWindow
            }
            return nil
        }

        func style2() -> UIWindow? {
            if #available(iOS 13.0, *) {
                return UIWindowScene.dtb.current()?
                    .windows
                    .first(where: { $0.isKeyWindow })
            }
            return nil
        }

        func style1() -> UIWindow? {
            return UIApplication.shared.keyWindow
        }
        return style3() ?? style2() ?? style1()
    }
}

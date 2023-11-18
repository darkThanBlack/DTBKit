//
//  SystemAdapter.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

/// 内存复用
struct DTBPerformance {
    
    ///
    static let decimalBehavior = NSDecimalNumberHandler(
        roundingMode: .plain,
        scale: 2,
        raiseOnExactness: false,
        raiseOnOverflow: false,
        raiseOnUnderflow: false,
        raiseOnDivideByZero: false
    )
}

extension DTB {
    
    /// Status bar height
    ///
    /// * I suggest using "safe area" instead of "const px" whenever possible.
    /// * Anyway, do *NOT* use it before ``window.makeKeyAndVisable``
    ///
    /// * 仅用于老代码兼容，新代码不应再使用
    /// * 同时注意不要在 ``window.makeKeyAndVisable`` 之前，一般也就是首页布局中调用
    ///
    /// [best practices](https://darkthanblack.github.io/blogs/05-bp-statusbar)
    public static var statusBarHeight: CGFloat {
        get {
            
            func style3() -> CGFloat? {
                if #available(iOS 13.0, *) {
                    return UIWindowScene.dtb.current()?.value.statusBarManager?.statusBarFrame.size.height
                }
                return nil
            }
            
            func style2() -> CGFloat? {
                if #available(iOS 11.0, *) {
                    return UIWindow.dtb.keyWindow()?.value.safeAreaInsets.top
                }
                return nil
            }
            
            func style1() -> CGFloat {
                return UIApplication.shared.statusBarFrame.size.height
            }
            return style3() ?? style2() ?? style1()
        }
        set {}
    }
}

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
            
//            func style3() -> CGFloat? {
//                if #available(iOS 13.0, *) {
//                    return UIWindowScene.dtb.keyScene()?.value.statusBarManager?.statusBarFrame.size.height
//                }
//                return nil
//            }
            
            func style2() -> CGFloat? {
                if #available(iOS 11.0, *) {
                    return UIWindow.dtb.keyWindow()?.safeAreaInsets.top
                }
                return nil
            }
            
            func style1() -> CGFloat {
                return UIApplication.shared.statusBarFrame.size.height
            }
            return style2() ?? style1()
        }
        set {}
    }
    
    public enum DebugTypes {
        
        case original
        
        case simple
        
        case fully
        
        case warning
        
        case error
        
        case assert
    }
    
    public static func print(
        _ item: @autoclosure (() -> Any),
        type: DTB.DebugTypes = .original,
        file: String = #file,
        line: Int = #line,
        function: String = #function
    ) {
        switch type {
        case .original:
#if DEBUG
            Swift.print(item())
#endif
            break
        case .simple:
#if DEBUG
            Swift.print("Sport Log file=\(file) line=\(line) function=\(function) \n\(item())")
#endif
            break
        case .fully:
#if DEBUG
            Swift.print("Sport Log file=\(file) line=\(line) function=\(function)")
            Swift.debugPrint("\(item())")
#endif
            break
        case .warning:
#if DEBUG
            Swift.print("Sport WARNING file=\(file) line=\(line) function=\(function)")
            Swift.debugPrint("\(item())")
#endif
            break
        case .error:
#if DEBUG
            Swift.print("Sport ERROR file=\(file) line=\(line) function=\(function)")
            Swift.debugPrint("\(item())")
#else
            // TODO: 堆栈打印 / 日志上报
#endif
            break
        case .assert:
#if DEBUG
            assert(false, "\(item())")
#else
            // TODO: 堆栈打印 / 日志上报
#endif
            break
        }
    }
    
    /// hf means "high fidelity"
    ///
    /// 高保真
    public enum HFBehaviors {
        
        /// 默认按设计图宽度等比缩放；参见 ``XM.Performance.designBaseSize``
        case scale
    }
    
    /// String regular candy | 正则表达式定义
    ///
    /// 参见 ``isRegular``
    ///
    /// e.g.
    /// ```
    ///     extension XM.Regulars {
    ///         public static func phone() -> Self {}
    ///     }
    ///
    ///     let success: Bool = "123".xm.isRegular(.phone())
    /// ```
    public struct Regulars {
        
        public let exp: String
        
        init(exp: String) {
            self.exp = exp
        }
    }
}

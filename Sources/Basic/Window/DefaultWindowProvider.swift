//
//  DefaultWindowProvider.swift
//  DTBKit
//
//  Created by moonShadow on 2025/11/28
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// Current window in general for nonscene-based app.
    ///
    /// 默认实现注定无法准确，用前请读最佳实践。
    ///
    /// [best practices](https://darkthanblack.github.io/blogs/04-bp-keywindow)
    /// [refer](https://stackoverflow.com/questions/57134259)
    public final class DefaultWindowProvider: Providers.WindowProvider {
        
        private weak var window: UIWindow? = nil
        
        public init(_ window: UIWindow? = nil) {
            self.window = window
        }
        
        public func keyWindow() -> UIWindow? {
            
            func style3() -> UIWindow? {
                if #available(iOS 15.0, *) {
                    return UIWindowScene.dtb.keyWindowScene()?.keyWindow
                }
                return nil
            }

            func style2() -> UIWindow? {
                if #available(iOS 13.0, *) {
                    return UIWindowScene.dtb.keyWindowScene()?
                        .windows
                        .first(where: { $0.isKeyWindow })
                }
                return nil
            }
            
            func style1() -> UIWindow? {
                return UIApplication.shared.keyWindow
            }
            return window ?? style3() ?? style2() ?? style1()
        }
    }
}

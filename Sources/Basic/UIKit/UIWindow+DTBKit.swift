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

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

extension DTB.Providers {
    
    public static let windowKey = DTB.ConstKey<any DTB.Providers.WindowProvider>("dtb.providers.window")
    
    public protocol WindowProvider {
        
        func keyWindow() -> UIWindow?
    }
}

extension StaticWrapper where T: UIWindow {
    
    /// Current window in general for nonscene-based app.
    @inline(__always)
    public func keyWindow() -> UIWindow? {
        return DTB.Providers.get(DTB.Providers.windowKey)?.keyWindow()
    }
}

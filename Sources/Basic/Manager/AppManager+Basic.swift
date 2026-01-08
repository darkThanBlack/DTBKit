//
//  AppManager+Basic.swift
//  DTBKit_Basic
//
//  Created by moonShadow on 2026/1/8
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.AppManager {
    
    public func isDebug() -> Bool {
#if DEBUG
        return true
#else
        return false
#endif
    }
    
    //MARK: - Info.plist: https://developer.apple.com/documentation/bundleresources/information-property-list
    
    /// 在手机桌面上显示的应用名称
    ///
    /// App name on iPhone desktop. ``CFBundleDisplayName``.
    public var displayName: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? ""
    }
    
    /// 版本号
    ///
    /// ``CFBundleShortVersionString``
    public var version: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? ""
    }
    
    /// 构建号
    ///
    /// ``CFBundleVersion``
    public var build: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? ""
    }
    
}

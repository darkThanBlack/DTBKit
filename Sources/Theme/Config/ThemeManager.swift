//
//  ThemeManager.swift
//  DTBKit
//
//  Created by moonShadow on 2025/9/26
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

/// 主题管理器，根据其他 manager 的复杂程度来决定要不要实现
public class ThemeManager {
    
    public static let shared = ThemeManager()
    
    private init() {}
    
    /// 设置可用主题并切换
    public func setupThemes(_ themeKeys: [String], current: String? = nil) {
        // todo...
    }

    /// 切换主题
    public func switchTheme(_ themeKey: String) {
        // todo...
    }
}

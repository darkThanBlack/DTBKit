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

/// 主题管理器
/// 提供统一的主题管理入口，整合颜色和国际化功能
public class ThemeManager {
    
    public static let shared = ThemeManager()
    
    /// 颜色管理器
    public let colorManager = ColorManager.shared
    
    /// 国际化管理器
    public let i18nManager = I18NManager.shared
    
    private init() {}
    
    /// 初始化默认主题
    public func setupDefaultTheme() {
        // 注册到 DTBKit 系统
        DTB.BasicInterface.registerProvider(colorManager, key: DTB.BasicInterface.colorKey)
        DTB.BasicInterface.registerProvider(i18nManager, key: DTB.BasicInterface.stringKey)
    }

    /// 切换语言
    public func switchLanguage(_ language: I18NManager.Languages) {
        i18nManager.update(language: language)
    }

    /// 设置可用主题并切换
    public func setupThemes(_ themeKeys: [String], current: String? = nil) {
        colorManager.themeKeys = themeKeys
        if let currentTheme = current, themeKeys.contains(currentTheme) {
            colorManager.update(theme: currentTheme)
        }
    }

    /// 切换主题
    public func switchTheme(_ themeKey: String) {
        colorManager.update(theme: themeKey)
    }
}

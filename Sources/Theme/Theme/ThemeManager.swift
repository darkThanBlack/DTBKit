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

extension DTB {
    
    /// 主题管理器，根据其他 manager 的复杂程度来决定要不要实现
    public class ThemeManager {
        
        public static let shared = ThemeManager()
        
        private init() {}
        
        public private(set) var currentBundle: Bundle = .main
        
        public func setup(bundle: Bundle? = nil) {
            currentBundle = bundle ?? .main
        }
        
        /// 1>由于 style 之间有依赖，顺序不能乱  2>发生变化时整体刷新
        public func reloadData() {
            // 颜色
            DTB.ColorManager.shared.reloadData()
            // 国际化字符串
            DTB.I18NManager.shared.reloadData()
            // 字体
            DTB.FontManager.shared.loadCustomFonts()
            // Styles 里的具体字段解析依赖于前面的 provider
            DTB.DefaultStylesProvider.shared.reloadData()
        }
    }
    
}

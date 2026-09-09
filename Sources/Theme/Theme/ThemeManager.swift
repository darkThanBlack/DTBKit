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

        /// 有序 bundle 链：头部优先（后覆盖），业务自己的 bundle 放前面，默认主题包放后面。
        ///
        /// 各 reader 遍历顺序约定：
        /// - 颜色 / 字符串 / 样式：`reversed()` 遍历（尾先填、头后填 = 头覆盖尾）
        /// - 字体 / 图片：正序遍历（先来先赢 = 头优先）
        public private(set) var bundles: [Bundle] = [.main]

        /// 设置完整链（业务显式传入，含 DTBKit 默认主题包）。
        ///
        /// - Parameter bundles: 头=高优先级；传空数组时回退为 `[.main]`
        public func setup(bundles: [Bundle]) {
            self.bundles = bundles.isEmpty ? [.main] : bundles
        }

        /// 兼容单 bundle 设置。
        public func setup(bundle: Bundle?) {
            setup(bundles: bundle.map { [$0] } ?? [.main])
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

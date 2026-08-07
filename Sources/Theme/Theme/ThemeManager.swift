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
        
        private init() {
            currentBundle = .dtb.create("DTBKitSportTheme") ?? .main
        }
        
        public private(set) var currentBundle: Bundle = .main
    }
    
}

//
//  Exclude.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/28.
//  Copyright © 2023 darkThanBlack. All rights reserved.
//

import DTBKit

//MARK: - same as .pch file

@_exported import DTBKit
@_exported import SnapKit


public enum ExampleApp {}

extension ExampleApp {
    
    /// 业务示例: 国际化
    public enum SupportLanguages: CaseIterable {
        case followSystem, zh, en
        
        public var key: String? {
            switch self {
            case .followSystem:  return nil
            case .zh:            return "zh"
            case .en:            return "en"
            }
        }
        
        public init(key: String?) {
            if key?.contains("zh") == true {
                self = .zh
                return
            }
            if key?.contains("en") == true {
                self = .en
                return
            }
            self = .followSystem
        }
        
        public var localTitle: String? {
            switch self {
            case .followSystem:  return .dtb.create("common_follow_system")
            case .zh:            return "简体中文"
            case .en:            return "English"
            }
        }
    }
    
    /// 业务示例: 色值
    public enum SupportColors: CaseIterable {
        case followSystem, light, dark
        
        public var key: String? {
            switch self {
            case .followSystem:  return nil
            case .light:         return "light"
            case .dark:          return "dark"
            }
        }
        
        public init(key: String?) {
            if key?.contains("light") == true {
                self = .light
                return
            }
            if key?.contains("dark") == true {
                self = .dark
                return
            }
            self = .followSystem
        }
        
        public var localTitle: String? {
            switch self {
            case .followSystem:  return .dtb.create("common_follow_system")
            case .light:         return .dtb.create("color_settings_light")
            case .dark:          return .dtb.create("color_settings_dark")
            }
        }
    }
}

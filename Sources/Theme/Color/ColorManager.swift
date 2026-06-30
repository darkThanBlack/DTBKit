//
//  ColorManager.swift
//  DTBKit
//
//  Created by moonShadow on 2025/9/26
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

/// 默认 ColorProvider 实现
extension DTB.ColorManager: DTB.Providers.ColorProvider {
    
    /// 实现 ColorProvider 协议
    @inline(__always)
    public func create(_ param: Any?) -> UIColor? {
        if let key = param as? String, let result = query(key) {
            return result
        }
        DTB.console.error("color: missing key=\(param ?? "")")
        if let result = UIColor.dtb.anyHex(param) {
            if case .autoDark = currentMode {
                return result.dtb.luminanceInvertedColor()
            } else {
                return result
            }
        }
        return nil
    }
}

extension DTB {
    
    /// 颜色管理器
    ///
    /// 在主工程中添加 "color_light.json" 文件即可响应, "color_" 是固定前缀, "light" 是标识符，如果设定为跟随系统模式，取值只会是 "dark" 和 "light" 之一
    public final class ColorManager {
        
        ///
        public enum Mode {
            
            case followSystem
            
            case light, dark
            
            case autoDark
            
            case custom(style: String)
            
            public init(value: String?) {
                switch value {
                case nil:               self = .followSystem
                case "light":           self = .light
                case "dark":            self = .dark
                case "auto_dark":       self = .autoDark
                case let .some(style):  self = .custom(style: style)
                }
            }
            
            public var localValue: String? {
                switch self {
                case .followSystem:      return nil
                case .light:             return "light"
                case .dark:              return "dark"
                case .autoDark:          return "auto_dark"
                case .custom(let style): return style
                }
            }
        }
        
        public static let shared = ColorManager()
        
        /// 当前模式
        public private(set) var currentMode: Mode
        
        /// 持久化
        private let userDefaultsKey = "DTBKitColorThemeKey"
        
        /// 避免重复取值
        private let systemStyle = systemColorStyle()
        
        /// 内存映射
        ///
        /// e.g.
        /// ```
        /// {"bg": { "light": "FFFFFF", "dark": "0x000000", "custom": "" } }
        /// ```
        private var mapper: [String: [String: UIColor]] = [:]
        
        private init() {
            currentMode = Mode(value: UserDefaults.standard.object(forKey: userDefaultsKey) as? String)
            
            colorMapParser()
            
            // 系统深浅色模式变化监听
//            NotificationCenter.default.addObserver(
//                self,
//                selector: #selector(colorMapParser),
//                name: UIApplication.didBecomeActiveNotification,
//                object: nil
//            )
        }
        
        /// 根据系统深浅色返回主题模式
        public static func systemColorStyle() -> String {
            if #available(iOS 12.0, *) {
                if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                    return "dark"
                }
                if UIScreen.main.traitCollection.userInterfaceStyle == .light {
                    return "light"
                }
            }
            if let style = Bundle.main.infoDictionary?["UIUserInterfaceStyle"] as? String {
                if style.lowercased() == "dark" {
                    return "dark"
                }
                if style.lowercased() == "light" {
                    return "light"
                }
            }
            console.error("system color key not found.")
            return "light"
        }
        
        /// 直接指定当前主题, mode 会被持久化到本地
        public func update(mode: Mode) {
            currentMode = mode
            UserDefaults.standard.set(mode.localValue, forKey: userDefaultsKey)
            UserDefaults.standard.synchronize()
            
            colorMapParser()
        }
        
        /// 获取颜色
        @inline(__always)
        public func query(_ key: String) -> UIColor? {
            let style = {
                switch currentMode {
                case .followSystem:
                    return systemStyle
                case .light:
                    return "light"
                case .dark, .autoDark:
                    return "dark"
                case .custom(let style):
                    return style
                }
            }()
            return mapper[key]?[style] ?? mapper[key]?["light"]
        }
        
        // MARK: - Parser
        
        @objc private func colorMapParser() {
            mapper.removeAll()
            
            guard let filePath = Bundle.main.path(forResource: "colors", ofType: "json") else {
                console.error("color: colors.json file not found")
                return
            }
            
            guard FileManager.default.fileExists(atPath: filePath),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
                  let dict = (try? JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])) as? [String: Any] else {
                console.error("color: colors.json parse fail")
                return
            }
            
            dict.forEach { key, value in
                // 没有指定，只有一个默认颜色
                if let hexString = value as? String,
                    let color = UIColor.dtb.anyHex(hexString) {
                    var result: [String: UIColor] = ["light": color]
                    // 自动推算深色模式颜色
                    if case .autoDark = currentMode {
                        result["dark"] = color.dtb.luminanceInvertedColor()
                    }
                    self.mapper[key] = result
                    return
                }
                
                // 有具体指定
                if let dict = value as? [String: String] {
                    var result: [String: UIColor] = [:]
                    dict.forEach({ result[$0.key] = UIColor.dtb.anyHex($0.value) })
                    
                    // 没有提供默认值 light，整个忽略
                    guard let light = result["light"] else {
                        return console.error("color: light style is empty, key=\(key)")
                    }
                    // 如果没有设置，再自动推算
                    if result["dark"] == nil, case .autoDark = currentMode {
                        result["dark"] = light.dtb.luminanceInvertedColor()
                    }
                    self.mapper[key] = result
                    return
                }
                
                console.error("color: value parse failed, key=\(key)")
            }
        }
        
    }
    
}

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
    public func create(_ param: Any?) -> UIColor {
        return query(param as? String ?? "") ?? .black
    }
}

extension DTB {
    
    /// 颜色管理器
    ///
    /// 在主工程中添加 "color_light.json" 文件即可响应, "color_" 是固定前缀, "light" 是标识符，如果设定为跟随系统模式，取值只会是 "dark" 和 "light" 之一
    public final class ColorManager {
        
        public static let shared = ColorManager()
        
        /// nil 代表跟随系统
        public private(set) var current: String? = nil
        
        private let localKey = "DTBKitColorThemeKey"
        
        /// 内存映射
        private var mapper: [String: UIColor] = [:]
        
        private init() {
            current = UserDefaults.standard.object(forKey: localKey) as? String
            colorMapParser()
            
            // 系统深浅色模式变化监听
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(colorMapParser),
                name: UIApplication.didBecomeActiveNotification,
                object: nil
            )
        }
        
        /// 根据系统深浅色模式返回主题键
        public func systemColorKey() -> String? {
            if #available(iOS 12.0, *) {
                if UIScreen.main.traitCollection.userInterfaceStyle == .dark {
                    return "dark"
                }
                if UIScreen.main.traitCollection.userInterfaceStyle == .light {
                    return "light"
                }
            }
            if let style = Bundle.main.infoDictionary?["UIUserInterfaceStyle"] as? String {
                if style == "Dark" {
                    return "dark"
                }
                if style == "Light" {
                    return  "light"
                }
            }
            return nil
        }
        
        /// 直接指定当前主题
        ///
        /// 如果传入 nil，代表是 followSystem，key 会根据系统深浅色模式自动选择; 如果设置了对应 key，代表是用户单独设置了主题标识。
        ///
        /// key 会被持久化到本地。
        public func update(key: String?) {
            current = key
            UserDefaults.standard.set(key, forKey: localKey)
            UserDefaults.standard.synchronize()
            
            colorMapParser()
        }
        
        /// 获取颜色
        @inline(__always)
        public func query(_ key: String) -> UIColor? {
            return mapper[key]
        }
        
        // MARK: - Parser
        
        @objc private func colorMapParser() {
            mapper.removeAll()
            
            guard let fileName = current ?? systemColorKey(),
                  let filePath = Bundle.main.path(forResource: fileName, ofType: "json") else {
                return
            }
            
            guard FileManager.default.fileExists(atPath: filePath),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
                  let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: String] else {
                return
            }
            
            dict.forEach { key, hexString in
                if let color = UIColor.dtb.hex(hexString) {
                    self.mapper[key] = color
                }
            }
        }
        
    }
    
}

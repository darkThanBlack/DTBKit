//
//  FontManager.swift
//  DTBKit
//
//  Created by moonShadow on 2025/10/9
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

/// 默认 FontProvider 实现
extension DTB.FontManager: DTB.Providers.FontProvider {
    
    /// 实现 FontProvider 协议
    @inline(__always)
    public func create(_ param: Any?) -> UIFont {
        return query(param as? [String: Any] ?? [:]) ?? UIFont.systemFont(ofSize: 17.0)
    }
}

extension DTB {
    
    /// 字体管理器
    ///
    /// 在主工程中添加 "fonts.json" 文件即可响应
    public final class FontManager {
        
        public static let shared = FontManager()
        
        /// 已注册的字体名称缓存
        private var registeredFonts: Set<String> = []
        
        private init() {
            loadCustomFonts()
        }
        
        /// 获取自定义字体
        @inline(__always)
        public func query(_ param: [String: Any]) -> UIFont? {
            guard let weight = param["weight"] as? UIFont.Weight,
                  let size = param["size"] as? CGFloat else {
                console.error("size or weight is nil")
                return nil
            }
            if let name = param["name"] as? String, name.isEmpty == false,
               let font = UIFont(name: "\(name)-\(weight.dtb.variant())", size: size) {
                return font
            } else {
                console.error("missing font: actual_name=\(param["name"] as? String ?? "")-\(weight.dtb.variant()), size=\(size)")
                return UIFont.systemFont(ofSize: size, weight: weight)
            }
        }
        
        // MARK: - Parser
        
        /// 加载支持的字体信息
        private func loadCustomFonts() {
            guard let filePath = Bundle.main.path(forResource: "fonts", ofType: "json") else {
                console.error("fonts.json file not found")
                return
            }
            
            guard FileManager.default.fileExists(atPath: filePath),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
                  let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
                console.error("fonts.json parse fail")
                return
            }
            
            // 根据配置文件注册所有支持的字体
            for (family, data) in dict {
                guard let info = data as? [String: Any] else {
                    continue
                }
                let type = (info["extension"] as? String) ?? "ttf"
                if let weights = info["variant"] as? [String] {
                    for weight in weights {
                        registerFontFromBundle(name: "\(family)-\(weight)", type: type)
                    }
                } else {
                    registerFontFromBundle(name: family, type: type)
                }
            }
        }
        
        /// 注册字体
        ///
        /// 须遵循 ``fontname-variant.extension`` 格式，大体遵循 PostScript 标准
        private func registerFontFromBundle(name: String, type: String = "ttf", bundle: Bundle = .main) {
            // 获取文件
            guard let url = bundle.url(forResource: name, withExtension: type) else {
                console.error("\(name).\(type) file not found")
                return
            }
            
            // 注册字体
            guard let fontDataProvider = CGDataProvider(url: url as CFURL),
                  let font = CGFont(fontDataProvider),
                  let fontName = font.postScriptName as String? else {
                console.error("\(name).\(type) name parse fail")
                return
            }
            
            // 避免重复
            if registeredFonts.contains(fontName) {
                return
            }
            
            var error: Unmanaged<CFError>?
            /// 手动释放: CTFontManagerUnregisterGraphicsFont
            let success = CTFontManagerRegisterGraphicsFont(font, &error)
            
            if success {
                registeredFonts.insert(fontName)
            } else if let error = error?.takeRetainedValue() {
                let errorDescription = CFErrorCopyDescription(error)
                console.error("font: \(fontName) register failed, error: \(String(describing: errorDescription))")
            }
        }
        
    }
    
}

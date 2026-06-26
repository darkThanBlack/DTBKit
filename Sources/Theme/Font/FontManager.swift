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
    public func create(_ param: Any?) -> UIFont? {
        return query(param as? [String: Any] ?? [:])
    }
}

extension DTB {
    
    /// 字体管理器
    ///
    /// 在主工程中添加 "fonts.json" 文件即可响应
    public final class FontManager {
        
        public static let shared = FontManager()
        
        /// 已注册的自定义字体名称
        private var customFontNames: Set<String> = []
        
        private init() {
            loadCustomFonts()
        }
        
        /// 获取自定义字体
        @inline(__always)
        public func query(_ param: [String: Any]?) -> UIFont? {
            return FontStyle(dict: param)?.getFont()
        }
        
        // MARK: - Parser
        
        /// 扫描 bundle 中所有 .ttf/.otf 并注册
        private func loadCustomFonts(in bundle: Bundle = .main) {
            // 先尝试子目录 “Fonts”——常规做法；若没有则遍历根目录
            let extensions = ["ttf", "otf"]
            let fileURLs: [URL] = extensions.reduce([]) { res, next in
                return res + (bundle.urls(forResourcesWithExtension: next, subdirectory: nil) ?? [])
            }
            guard fileURLs.isEmpty == false else {
                console.log("font: custom .ttf/.otf file no found in bundle")
                return
            }
            fileURLs.forEach({ registerCustomFontFromURL($0) })
        }
        
        /// 注册字体
        ///
        /// 须遵循 ``fontname-variant.extension`` 格式，大体遵循 PostScript 标准
        private func registerCustomFontFromURL(_ url: URL) {
            // 注册字体
            guard let fontDataProvider = CGDataProvider(url: url as CFURL),
                  let font = CGFont(fontDataProvider),
                  let fontName = font.postScriptName as String? else {
                console.error("font: failed to read url=\(url.absoluteString)")
                return
            }
            
            // 避免重复
            if customFontNames.contains(fontName) {
                console.error("font: found duplicate font name=\(fontName)")
                return
            }
            
            var error: Unmanaged<CFError>?
            /// 手动释放: CTFontManagerUnregisterGraphicsFont
            let success = CTFontManagerRegisterGraphicsFont(font, &error)
            
            if success {
                customFontNames.insert(fontName)
            } else if let error = error?.takeRetainedValue() {
                let errorDescription = CFErrorCopyDescription(error)
                console.error("font: failed register custom font name=\(fontName), error=\(String(describing: errorDescription))")
            }
        }
        
    }
    
}

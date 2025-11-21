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
extension FontManager: FontProvider {

    /// 实现 FontProvider 协议
    @inline(__always)
    public func create(_ param: Any?) -> UIFont {
        return query(param as? [String: Any] ?? [:]) ?? UIFont.systemFont(ofSize: 17.0)
    }
}

/// 字体管理器
public final class FontManager {

    public static let shared = FontManager()

    /// 配置文件
    private var configFileHandler: ((_ key: String?) -> ThemeConfigFile)? = nil

    /// 已注册的字体名称缓存
    private var registeredFonts: Set<String> = []

    private init() {}

    /// 指定 json 配置文件; 必须调用
    ///
    /// 配置文件用于声明支持的字体类型和名称，FontManager 会根据此文件注册字体
    public func setupConfigFile(handler: ((_ key: String?) -> ThemeConfigFile)?) {
        self.configFileHandler = handler
        
        loadCustomFonts()
    }
    
    /// 获取自定义字体
    @inline(__always)
    public func query(_ param: [String: Any]) -> UIFont? {
        guard let weight = param["weight"] as? UIFont.Weight,
              let size = param["size"] as? CGFloat else {
#if DEBUG
            print("font MISSING: size or weight is nil")
#endif
            return nil
        }
        if let name = param["name"] as? String, name.isEmpty == false,
           let font = UIFont(name: "\(name)-\(weight.dtb.variant())", size: size) {
            return font
        } else {
#if DEBUG
            print("font MISSING: actual_name=\(param["name"] as? String ?? "")-\(weight.dtb.variant()), size=\(size)")
#endif
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
    }

    // MARK: - Parser
    
    /// 加载支持的字体信息
    private func loadCustomFonts() {
        guard let fileModel = self.configFileHandler?(nil) else {
            return
        }

        guard let filePath = {
            if let path = fileModel.path, path.isEmpty == false {
                return path
            }
            if let name = fileModel.name, name.isEmpty == false {
                return Bundle.main.path(forResource: name, ofType: "json")
            }
            return nil
        }() else {
            return
        }

        guard FileManager.default.fileExists(atPath: filePath),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
              let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
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
            print("FontManager: Font file \(name).\(type) not found in bundle")
            return
        }
        
        // 注册字体
        guard let fontDataProvider = CGDataProvider(url: url as CFURL),
              let font = CGFont(fontDataProvider),
              let fontName = font.postScriptName as String? else {
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
            print("FontManager: Failed to register font \(fontName): \(String(describing: errorDescription))")
        }
    }
}

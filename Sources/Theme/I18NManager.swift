//
//  I18NManager.swift
//  DTBKit
//
//  Created by moonShadow on 2025/9/26
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

/// 默认 StringProvider 实现
extension I18NManager: StringProvider {
    
    /// 实现 StringProvider 协议
    @inline(__always)
    public func create(_ param: Any?) -> String {
        return query(param as? String ?? "")
    }
    
    /// 实现 StringProvider 协议
    @inline(__always)
    public func create(format key: String, _ args: [String]) -> String {
        return query(format: key, args)
    }
}

/// 国际化管理器
///
/// 默认在主工程中添加 "string_zh.json" 文件即可响应, "string_" 是固定前缀, "zh" 是语言标识符，用 "-" 分割后从后往前寻找
public final class I18NManager {
    
    public static let shared = I18NManager()
    
    /// 当前标识; nil 代表跟随系统
    public private(set) var currentKey: String? = nil
    
    /// 标识持久化
    private let localKey = "DTBKitI18NLocalKey"
    
    /// 内存映射
    private var mapper: [String: String] = [:]
    
    /// 配置文件
    //    private var configFileHandler: ((_ key: String?) -> ThemeConfigFile)? = nil
    
    private init() {
        currentKey = UserDefaults.standard.object(forKey: localKey) as? String
        
        i18nMapParser()
        
        // 系统调整语言时会重启, 无需监听
        // NSLocale.currentLocaleDidChangeNotification
    }
    
    public func fullLanguageCode() -> String? {
        if #available(iOS 16, *) {
            return Locale.current.identifier
        } else {
            return Locale.preferredLanguages.first
        }
    }
    
    //    /// 可能出现 "zh-HK" 的形式
    //    public func limitLanguageCode() -> String? {
    //        if #available(iOS 16, *) {
    //            return Locale.currentKey.language.languageCode?.identifier
    //        } else {
    //            return Locale.preferredLanguages.first?.components(separatedBy: "-").first
    //        }
    //    }
    
    /// 直接指定当前语言
    ///
    /// 如果传入 nil，代表是 followSystem，key 会尝试从 ``Locale`` 中获取; 如果设置了对应 key，代表是用户单独设置了语言标识。
    ///
    /// key 会被持久化到本地。
    public func update(key: String?) {
        currentKey = key
        UserDefaults.standard.set(key, forKey: localKey)
        UserDefaults.standard.synchronize()
        
        i18nMapParser()
    }
    
    /// 查询字符串
    @inline(__always)
    public func query(_ key: String) -> String {
        if mapper[key] == nil {
            error("missing key=\(key)")
        }
        return mapper[key] ?? "\(key)"
    }
    
    /// 允许字符串拼接，格式: ${0}, ${1}...
    @inline(__always)
    public func query(format key: String, _ args: String...) -> String {
        return query(format: key, args)
    }
    
    /// 重载以允许参数传递
    @inline(__always)
    public func query(format key: String, _ args: [String]) -> String {
        guard var result = mapper[key] else {
            error("missing key=\(key)")
            return "\(key)"
        }
        for (index, item) in args.enumerated() {
            result = result.replacingOccurrences(of: "${\(index)}", with: item)
        }
        return result
    }
    
    // MARK: - Parser
    
    ///
    @inline(__always)
    private func error(_ message: String) {
#if DEBUG
        print("i18N ERROR: \(message)")
#endif
    }
    
    private func i18nMapParser() {
        
        /// "string_zh-CN.json"
        func getMapperBy(key: String) -> [String: String]? {
            guard let filePath = Bundle.main.path(forResource: "string_\(key)", ofType: "json"),
                  FileManager.default.fileExists(atPath: filePath),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
                  let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: String],
                  dict.isEmpty == false else {
                return nil
            }
            return dict
        }
        
        /// Step 1. "zh-Hans-US"
        /// Step 2. "zh-Hans"
        /// Step 3. "zh"
        func recursionLanguageCodeBy(list: [String]) -> [String: String]? {
            let result = getMapperBy(key: list.joined(separator: "-"))
            if (result != nil) || (list.count == 1) {
                return result
            } else {
                return recursionLanguageCodeBy(list: list.dropLast())
            }
        }
        
        let result: [String: String]? = {
            // manual
            if let manual = currentKey, manual.isEmpty == false {
                if let result = getMapperBy(key: manual) {
                    return result
                } else {
                    error("is manual mode but missing file=\(manual), will use follow system mode")
                }
            }
            // follow system
            guard let full = fullLanguageCode(), full.isEmpty == false else {
                error("query system language code fail")
                return nil
            }
            return recursionLanguageCodeBy(list: full.components(separatedBy: "-"))
        }()
        error("mapper query fail")
        
        mapper.removeAll()
        result?.forEach { key, value in
            self.mapper[key] = value
        }
    }
    
}

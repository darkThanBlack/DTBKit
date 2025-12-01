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
extension DTB.I18NManager: DTB.Providers.StringProvider {
    
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

extension DTB {
    
    /// 国际化管理器
    ///
    /// 在主工程中添加 "string_zh.json" 文件即可响应, "string_" 是固定前缀, "zh" 是语言标识符，用 "-" 分割后从后往前寻找
    public final class I18NManager {
        
        public static let shared = I18NManager()
        
        /// 当前标识; nil 代表跟随系统
        public private(set) var currentKey: String? = nil
        
        /// 标识持久化
        private let localKey = "DTBKitI18NLocalKey"
        
        /// 内存映射
        private var mapper: [String: String] = [:]
        
        private init() {
            currentKey = UserDefaults.standard.object(forKey: localKey) as? String
            
            i18nMapParser()
            
            // 系统调整语言时会重启, 无需监听
            // NSLocale.currentLocaleDidChangeNotification
        }
        
        /// 当前系统语言标识符 (BCP-47)
        public func fullLanguageCode() -> String? {
            if #available(iOS 16, *) {
                return Locale.current.language.minimalIdentifier
            } else {
                return Locale.preferredLanguages.first
            }
        }
        
        /// 可能出现 "zh-HK" 的形式
//        public func limitLanguageCode() -> String? {
//            if #available(iOS 16, *) {
//                return Locale.current.language.languageCode?.identifier
//            } else {
//                return Locale.preferredLanguages.first?.components(separatedBy: "-").first
//            }
//        }
        
        /// 直接指定当前语言
        ///
        /// 如果传入 nil，代表是 followSystem，key 会尝试从 ``Locale`` 中获取; 如果设置了对应 key，代表是用户单独设置了语言标识。
        ///
        /// key 的取值是基于 fullLanguageCode() 方法的降级策略。
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
                console.error("missing key=\(key)")
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
                console.error("missing key=\(key)")
                return "\(key)"
            }
            for (index, item) in args.enumerated() {
                result = result.replacingOccurrences(of: "${\(index)}", with: item)
            }
            return result
        }
        
        // MARK: - Parser
        
        /// "string_zh-CN.json"
        private func getMapperBy(key: String) -> [String: String]? {
            guard let filePath = Bundle.main.path(forResource: "string_\(key)", ofType: "json"),
                  FileManager.default.fileExists(atPath: filePath),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
                  let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: String],
                  dict.isEmpty == false else {
                return nil
            }
            console.print("string_\(key).json was successfully parsed")
            return dict
        }
        
        /// 递归查询 key; 更优解是拉表后全等查询; 注意 CFBundleDevelopmentRegion 的影响
        ///
        ///
        /// Search step: "zh-Hans-US" -> "zh-Hans" -> "zh"
        /// separator:  bcp47 == "-", icu / cldr == "_", Locale.IdentifierType
        private func parseLanguageCodeBy(key: String, separator: String) -> [String: String]? {
            let list = key.components(separatedBy: separator)
            guard list.count > 0 else {
                return nil
            }
            if list.count == 1 {
                return getMapperBy(key: list.first ?? "")
            } else {
                if let result = getMapperBy(key: list.joined(separator: separator)), result.isEmpty == false {
                    return result
                } else {
                    return parseLanguageCodeBy(key: list.dropLast().joined(separator: separator), separator: separator)
                }
            }
        }
        
        private func i18nMapParser() {
            mapper.removeAll()
            
            guard let result = {
                // manual
                if let manual = currentKey, manual.isEmpty == false {
                    if let result = getMapperBy(key: manual) {
                        return result
                    } else {
                        DTB.console.error("user set key=\(manual) but file not found, will use follow system mode")
                    }
                }
                // follow system
                guard let full = fullLanguageCode(), full.isEmpty == false else {
                    console.error("query system language code fail")
                    return nil
                }
                if let result = parseLanguageCodeBy(key: full, separator: "-"), result.isEmpty == false {
                    return result
                } else {
                    console.error("parse with bcp47 rule fail")
                }
                if let result = parseLanguageCodeBy(key: full, separator: "_"), result.isEmpty == false {
                    return result
                } else {
                    console.error("parse with cldr rule fail")
                }
                return nil
            }(), result.isEmpty == false else {
                return
            }
            
            result.forEach { key, value in
                self.mapper[key] = value
            }
        }
        
    }
    
}

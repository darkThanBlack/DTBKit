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
    public func create(_ param: Any?) -> String? {
        return query(param as? String ?? "")
    }
}

/// 国际化管理器
public final class I18NManager {

    public static let shared = I18NManager()
    
    private let localKey = "DTBKitI18NLocalKey"

    private var current: Languages = .followSystem
    
    /// 内存映射
    private var mapper: [String: String] = [:]
    
    private init() {
        let lan: Languages = {
            if let value = UserDefaults.standard.object(forKey: localKey) as? String,
               let result = Languages(rawValue: value) {
                return result
            }
            return .followSystem
        }()
        current = lan
        i18nMapParser()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(i18nMapParser),
            name: NSLocale.currentLocaleDidChangeNotification,
            object: nil
        )
    }

    public enum Languages: String, CaseIterable {

        case followSystem
        case zh
        case en

        public var desc: String {
            switch self {
            case .followSystem:
                return "跟随系统"
            case .zh:
                return "简体中文"
            case .en:
                return "English"
            }
        }
    }
    
    public func currentLanguage() -> Languages {
        return current
    }
    
    /// 自定义配置文件路径
    public var customFilePathHandler: ((_ lan: Languages) -> String?)? = nil
    
    /// 更新指定模式
    public func update(language value: Languages) {
        current = value
        
        UserDefaults.standard.set(value.rawValue, forKey: localKey)
        UserDefaults.standard.synchronize()
        i18nMapParser()
    }
    
    /// 查询字符串
    public func query(_ key: String) -> String {
        return mapper[key] ?? key
    }

    /// 允许字符串拼接，格式: ${0}, ${1}...
    public func query(format key: String, _ args: String...) -> String {
        return query(format: key, args)
    }

    /// 重载以允许参数传递
    public func query(format key: String, _ args: [String]) -> String {
        guard var result = mapper[key] else {
            return key
        }
        for (index, item) in args.enumerated() {
            result = result.replacingOccurrences(of: "${\(index)}", with: item)
        }
        return result
    }

    // MARK: - Parser

    @objc private func i18nMapParser() {
        mapper.removeAll()
        
        guard let filePath = {
            if let path = self.customFilePathHandler?(current), path.isEmpty == false {
                return path
            } else {
                guard let lanStr = {
                    switch current {
                    case .followSystem:
                        return Locale.preferredLanguages.first.map { String($0.prefix(2)) }
                    case .zh:
                        return "zh"
                    case .en:
                        return "en"
                    }
                }() else {
                    return nil
                }
                return Bundle.main.path(forResource: "string_\(lanStr)", ofType: "json")
            }
        }() else {
            return
        }
        
        guard FileManager.default.fileExists(atPath: filePath),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
              let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: String] else {
            return
        }
        dict.forEach { key, value in
            self.mapper[key] = value
        }
    }
}

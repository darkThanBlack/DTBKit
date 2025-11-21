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
extension ColorManager: ColorProvider {

    /// 实现 ColorProvider 协议
    @inline(__always)
    public func create(_ param: Any?) -> UIColor {
        return query(param as? String ?? "") ?? .black
    }
}

/// 颜色管理器
public final class ColorManager {

    public static let shared = ColorManager()

    public enum Modes: CaseIterable {
        case followSystem, manual
    }

    /// 指示当前模式
    public var mode: Modes {
        if let key = current, key.isEmpty == false {
            return .manual
        } else {
            return .followSystem
        }
    }

    /// 配置文件
    private var configFileHandler: ((_ key: String?) -> ThemeConfigFile)? = nil

    private let localKey = "DTBKitColorThemeKey"

    /// nil 代表跟随系统
    private var current: String? = nil

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

    /// 指定 json 配置文件; 必须调用
    ///
    /// 如果在 update(key:) 中传入 nil，代表是 followSystem 模式，会根据系统深浅色模式返回 "light" 或 "dark";
    /// 否则代表用户自行设置，将 update(key:) 传入的值原样返回
    public func setupConfigFile(handler: ((_ key: String?) -> ThemeConfigFile)?) {
        self.configFileHandler = handler
    }

    /// 直接指定当前主题; 必须调用; 必须在 ``setupConfigFile(handler:)`` 后调用
    ///
    /// 如果传入 nil，代表是 followSystem，key 会根据系统深浅色模式自动选择; 如果设置了对应 key，代表是用户单独设置了主题标识。
    ///
    /// key 会被持久化到本地。你需要通过 setupConfigFile 提供 json 配置文件。
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

        guard let fileModel = {
            switch mode {
            case .followSystem:
                return self.configFileHandler?({
                    // 根据系统深浅色模式返回主题键
                    if #available(iOS 12.0, *) {
                        return UIScreen.main.traitCollection.userInterfaceStyle == .dark ? "dark" : "light"
                    } else {
                        return "light" // 默认浅色
                    }
                }())
            case .manual:
                return self.configFileHandler?(current)
            }
        }() else {
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

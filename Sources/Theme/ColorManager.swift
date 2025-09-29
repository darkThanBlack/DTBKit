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
    public func create(_ param: Any?) -> UIColor? {
        return query(param as? String ?? "")
    }
}

/// 颜色管理器
public final class ColorManager {

    public static let shared = ColorManager()

    private let localKey = "DTBKitColorThemeKey"

    private var currentKey: String = ""

    /// 可用主题列表
    public var themeKeys: [String] = [] {
        didSet {
            if !themeKeys.contains(currentKey) {
                currentKey = themeKeys.first ?? ""
            }
            colorMapParser()
        }
    }

    /// 内存映射
    private var mapper: [String: UIColor] = [:]

    private init() {
        let key: String = {
            if let value = UserDefaults.standard.object(forKey: localKey) as? String {
                return value
            }
            return ""
        }()
        currentKey = key
        colorMapParser()

        // 备用：系统深浅色模式变化监听
        // NotificationCenter.default.addObserver(
        //     self,
        //     selector: #selector(colorMapParser),
        //     name: UIApplication.didBecomeActiveNotification,
        //     object: nil
        // )
    }

    public func currentTheme() -> String {
        return currentKey
    }

    /// 自定义颜色配置处理器
    public var customColorHandler: ((_ themeKey: String) -> [String: UIColor]?)? = nil

    /// 更新主题
    public func update(theme key: String) {
        guard themeKeys.contains(key) else { return }

        currentKey = key
        UserDefaults.standard.set(key, forKey: localKey)
        UserDefaults.standard.synchronize()
        colorMapParser()
    }

    /// 获取颜色
    public func query(_ key: String) -> UIColor? {
        return mapper[key]
    }

    // MARK: - Parser

    @objc private func colorMapParser() {
        mapper.removeAll()

        guard !currentKey.isEmpty else { return }

        var colorDict: [String: UIColor]?

        // 优先使用自定义处理器
        if let handler = customColorHandler {
            colorDict = handler(currentKey)
        } else {
            // 默认从 Bundle 读取配置文件
            if let path = Bundle.main.path(forResource: "color_\(currentKey)", ofType: "json") {
                colorDict = loadColorsFromFile(path)
            }
        }

        guard let colors = colorDict else { return }

        colors.forEach { key, color in
            self.mapper[key] = color
        }
    }

    private func loadColorsFromFile(_ path: String) -> [String: UIColor]? {
        guard FileManager.default.fileExists(atPath: path),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let dict = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: String] else {
            return nil
        }

        var colorDict: [String: UIColor] = [:]
        for (key, hexString) in dict {
            if let color = UIColor.dtb.hex(hexString) {
                colorDict[key] = color
            }
        }
        return colorDict
    }
}

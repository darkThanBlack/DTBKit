//
//  UIColor+Theme.swift
//  DTBKit
//
//  Created by moonShadow on 2023/10/2
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension StaticWrapper where T: UIColor {
    
    /// Create color with provider.
    ///
    /// 颜色调用收束
    @inline(__always)
    public func create(_ param: Any?) -> UIColor {
        if let p = DTB.Providers.get(DTB.Providers.colorKey), let result = p.create(param) {
            return result
        }
        if let s = param as? String {
            return .dtb.percentHex(s)
        }
        if let i = param as? Int64 {
            return .dtb.hex(i)
        }
        return .clear
    }
}

extension StaticWrapper where T: UIColor {
    
    /// 在 hex(rgba:) 的基础上，兼容 RRGGBB.alpha, alpha 是一个十进制的两位数(0, 100)
    ///
    /// 常见于某些设计工具直接复制
    public func percentHex(_ value: String?) -> UIColor {
        guard let upper = value?.uppercased()
            .replacingOccurrences(of: "^#", with: "", options: .regularExpression)
            .replacingOccurrences(of: "^0X", with: "", options: .regularExpression) else {
            return .clear
        }
        if upper.contains("."),
           let rgb = upper.components(separatedBy: ".").first,
           let a = upper.components(separatedBy: ".").last,
           let ap = Int(a),
           ap >= 0 {
            return hex(rgb, alpha: CGFloat(ap / 100))
        }
        return hex(rgba: value)
    }
    
    /// 0xRRGGBB
    @inline(__always)
    public func hex(_ value: Int64, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0xFF00) >> 8) / 255.0,
            blue: CGFloat(value & 0xFF) / 255.0,
            alpha: alpha
        )
    }
    
    /// RRGGBB / "#RRGGBB" / "0xRRGGBB"
    @inline(__always)
    public func hex(_ value: String?, alpha: CGFloat = 1.0) -> UIColor {
        guard let upper = value?.uppercased()
            .replacingOccurrences(of: "^#", with: "", options: .regularExpression)
            .replacingOccurrences(of: "^0X", with: "", options: .regularExpression),
              upper.count == 6 else {
            DTB.console.error(value)
            return .clear
        }
        
        guard let r = Int(upper.prefix(2), radix: 16),
              let g = Int(upper.dropFirst(2).prefix(2), radix: 16),
              let b = Int(upper.dropFirst(4).prefix(2), radix: 16) else {
            DTB.console.error(value)
            return .clear
        }
        
        return UIColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: alpha
        )
    }
    
    /// 0xAARRGGBB
    @inline(__always)
    public func hex(argb value: Int64) -> UIColor {
        return UIColor(
            red: CGFloat((value & 0x00FF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x0000FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x000000FF) / 255.0,
            alpha: CGFloat((value & 0xFF000000) >> 24) / 255.0
        )
    }
    
    /// AARRGGBB / "#AARRGGBB" / "0xAARRGGBB"
    @inline(__always)
    public func hex(argb value: String?) -> UIColor {
        guard let upper = value?.uppercased()
            .replacingOccurrences(of: "^#", with: "", options: .regularExpression)
            .replacingOccurrences(of: "^0X", with: "", options: .regularExpression) else {
            DTB.console.error(value)
            return .clear
        }
        guard upper.count == 8 else {
            return hex(upper)
        }
        
        guard let a = Int(upper.prefix(2), radix: 16),
              let r = Int(upper.dropFirst(2).prefix(2), radix: 16),
              let g = Int(upper.dropFirst(4).prefix(2), radix: 16),
              let b = Int(upper.dropFirst(6).prefix(2), radix: 16) else {
            DTB.console.error(value)
            return .clear
        }
        
        return UIColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
    
    /// 0xRRGGBBAA
    @inline(__always)
    public func hex(rgba value: Int64) -> UIColor {
        return UIColor(
            red: CGFloat((value & 0xFF000000) >> 24) / 255.0,
            green: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            blue: CGFloat((value & 0xFF00) >> 8) / 255.0,
            alpha: CGFloat(value & 0xFF) / 255.0
        )
    }
    
    /// RRGGBBAA / "#RRGGBBAA" / "0xRRGGBBAA"
    @inline(__always)
    public func hex(rgba value: String?) -> UIColor {
        guard let upper = value?.uppercased()
            .replacingOccurrences(of: "^#", with: "", options: .regularExpression)
            .replacingOccurrences(of: "^0X", with: "", options: .regularExpression) else {
            DTB.console.error(value)
            return .clear
        }
        guard upper.count == 8 else {
            return hex(upper)
        }
        
        guard let r = Int(upper.prefix(2), radix: 16),
              let g = Int(upper.dropFirst(2).prefix(2), radix: 16),
              let b = Int(upper.dropFirst(4).prefix(2), radix: 16),
              let a = Int(upper.dropFirst(6).prefix(2), radix: 16) else {
            DTB.console.error(value)
            return .clear
        }
        
        return UIColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }
}

extension Wrapper where Base == UIColor {
    
    /// 经验阈值: 0.5
    public func isLight() -> Bool {
        return luminance() > 0.5
    }
    
    /// 经验阈值: 0.5
    public func isDark() -> Bool {
        return luminance() <= 0.5
    }
    
    /// 相对亮度，遵循 CIE 1931, WCAG 2 标准
    public func luminance() -> CGFloat {
        /// 1. 提取 RGB 分量
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        me.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        /// 2. 线性化（Gamma 解码）
        ///
        /// 公式:
        /// ```
        ///    if c <= 0.03928:
        ///        linear = c / 12.92          // 暗部（sRGB 标准定义的线性段）
        ///    else:
        ///        linear = ((c + 0.055) / 1.055) ^ 2.4   // 亮部（gamma 2.4 解码）
        ///
        /// ```
        ///
        /// 公式来源: sRGB 色彩空间标准 (IEC 61966-2-1)
        func adjust(_ c: CGFloat) -> CGFloat {
            if c <= 0.03928 {
                return c / 12.92  // 暗部（sRGB 标准定义的线性段）
            } else {
                return pow((c + 0.055) / 1.055, 2.4)  // 亮部（gamma 2.4 解码）
            }
        }
        
        // 3. 加权求和 → 最终相对亮度
        //
        // 公式来源: CIE 1931 标准色度观察者，代表人眼对不同波长光的感知权重
        return 0.2126 * adjust(r) + 0.7152 * adjust(g) + 0.0722 * adjust(b)
    }
    
}

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
    ///
    /// 注意: 由于大部分 UIKit 的 color 属性是 nonNull, fail 时给一个 .red 作为强提示
    @inline(__always)
    public func create(_ param: Any?) -> UIColor {
        return DTB.Providers.get(DTB.Providers.colorKey)?.create(param) ?? .red
    }
    
    @inline(__always)
    public func create(nullable param: Any?) -> UIColor? {
        return DTB.Providers.get(DTB.Providers.colorKey)?.create(param)
    }
}

extension StaticWrapper where T: UIColor {
    
    @inline(__always)
    private func upper(_ value: String) -> String {
        return value.uppercased()
            .replacingOccurrences(of: "^#", with: "", options: .regularExpression)
            .replacingOccurrences(of: "^0X", with: "", options: .regularExpression)
    }
    
    /// 兼容模式
    ///
    /// - 允许 Int64 / String
    /// - 允许 "#" "0x" 前缀
    /// - 允许 rgb, rgba, rgb.a
    public func anyHex(_ value: Any?) -> UIColor? {
        if let i = value as? Int64 {
            return hex(i)
        }
        guard let value = value as? String else { return nil }
        let s = upper(value)
        
        // argb 是 android 规范，iOS 平台上默认采用 rgba 规范
        if s.count == 6, let i = Int64(s, radix: 16) {
            return hex(i)
        }
        if s.count == 8, let i = Int64(s, radix: 16) {
            return hex(rgba: i)
        }
        
        // 兼容 rgb.a 形式, a 是一个十进制的两位数(0, 100)，代表透明度的百分比
        //
        // 常见于某些设计工具的自定义规范
        if s.contains("."),
           let rgb = s.components(separatedBy: ".").first,
           let a = s.components(separatedBy: ".").last,
           rgb.count == 6,
           let ap = Int(a),
           ap >= 0 {
            return hex(rgb, alpha: CGFloat(ap / 100))
        }
        DTB.console.error(s)
        return nil
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
    public func hex(_ value: String, alpha: CGFloat = 1.0) -> UIColor {
        return self.hex(Int64(self.upper(value), radix: 16) ?? 0, alpha: alpha)
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
    public func hex(argb value: String) -> UIColor {
        return self.hex(argb: Int64(self.upper(value), radix: 16) ?? 0)
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
    public func hex(rgba value: String) -> UIColor {
        return self.hex(rgba: Int64(self.upper(value), radix: 16) ?? 0)
    }
}

extension Wrapper where Base == UIColor {
    
    /// WCAG 2 经验阈值: 0.5
    public func isLight() -> Bool {
        return luminance() > 0.5
    }
    
    /// WCAG 2 经验阈值: 0.5
    public func isDark() -> Bool {
        return luminance() <= 0.5
    }
    
    /// 相对亮度 (Relative Luminance)
    ///
    /// - 遵循 CIE 1931
    /// - 注意，和 HSB 的 Brightness 分量是两种概念
    public func luminance() -> CGFloat {
        /// 1. 提取 RGB 分量
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        me.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        /// 2. 线性化（Gamma 解码）
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
    
    /// 根据当前的 luminance，调整 hsb.b 来逼近 1 - luminance
    ///
    /// 作用: 如果原始颜色视觉可见，那么 invert 以后新颜色视觉依然可见
    public func luminanceInvertedColor() -> UIColor {
        let targetLuminance = 1.0 - self.luminance()
        
        // 在保持色相/饱和度的前提下，逼近目标亮度
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        me.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        // 二分搜索：找到最接近目标亮度的 HSB brightness
        var low: CGFloat = 0, high: CGFloat = 1.0
        // 2^8=256
        for _ in 0..<8 {
            let mid = (low + high) / 2
            let testColor = UIColor(hue: h, saturation: s, brightness: mid, alpha: a)
            if testColor.dtb.luminance() < targetLuminance {
                low = mid
            } else {
                high = mid
            }
        }
        
        return UIColor(hue: h, saturation: s, brightness: (low + high) / 2, alpha: a)
    }
    
}

//
//  CGFloat+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/29
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    
import UIKit
import Foundation

/// Type convert
///
/// 基础类型转换。
///
/// 1. "init" vs. "exactly init"
/// 2. "NaN" vs. nil
/// 3. "high bits to low bits" vs. nil
extension Wrapper where Base: BinaryFloatingPoint {
    
    ///
    @inline(__always)
    public func rounded(_ roundRule: FloatingPointRoundingRule? = nil) -> Self {
        if let rule = roundRule {
            return Wrapper(me.rounded(rule))
        }
        return Wrapper(me.rounded())
    }
}

/// String
///
/// 字符串处理。
extension Wrapper where Base: BinaryFloatingPoint {
    
    /// Convert to string.
    ///
    /// 转字符串。
    @inline(__always)
    public func string() -> Wrapper<String> {
        return "\(me)".dtb
    }
    
    /// Convert to ``NSDecimalNumber``.
    ///
    /// ```
    /// 1.dtb.nsDecimal
    ///     .plus("1.0")
    ///     .div(3, scale: 3, rounding: .down)
    ///     .double.value === 0.666
    /// ```
    @inline(__always)
    public func nsDecimal() -> Wrapper<NSDecimalNumber>? {
        let result = NSDecimalNumber(string: "\(me)")
        return result == NSDecimalNumber.notANumber ? nil : result.dtb
    }
    
    /// Convert to string with numberFormatter.
    ///
    /// 格式化字符串。
    ///
    /// For example:
    /// ```
    ///     /// Use preset formatter
    ///     let a = 2.1.dtb.toString(.dtb.CNY)?.value
    ///
    ///     /// Custom formatter
    ///     let b = 2.dtb.double.toString(NumberFormatter().dtb.decimal(2).rounded(.halfDown).prefix("¥", negative: "-¥").value)
    /// ```
    @inline(__always)
    public func toString(_ formatter: NumberFormatter) -> Wrapper<String>? {
        return formatter.dtb.string(from: NSNumber(value: Double(me)))
    }
    
}

/// Date
extension Wrapper where Base: BinaryFloatingPoint {
    
    /// From 's' timeStamp (length == 10) | 从 10 位秒级时间戳生成
    @inline(__always)
    public func sDate() -> Wrapper<Date>? {
        return Date.dtb.create(s: Double(me))?.dtb
    }
    
    /// From 'ms' timeStamp (length == 13) | 从 13 位毫秒级时间戳生成
    @inline(__always)
    public func msDate() -> Wrapper<Date>? {
        return Date.dtb.create(ms: Double(me))?.dtb
    }
}

///
extension Wrapper where Base: BinaryFloatingPoint {
    
    /// Cut dicimal places.
    ///
    /// 截取小数后 x 位。
    ///
    /// Example: ``1.26.dtb.place(1).value = 1.2``
    @inline(__always)
    public func places(_ value: Int) -> Double {
        let div = pow(10.0, Double(value))
        return ((Double(me) * div).rounded(.down) / div)
    }
}

/// High fidelity design
///
/// 高保真。
extension Wrapper where Base: BinaryFloatingPoint {
    
    /// High fidelity design | 高保真
    ///
    /// more detail in ``HFBehaviors``
    @inline(__always)
    public func hf(_ behavior: DTB.HFBehaviors = .scale) -> CGFloat {
        switch behavior {
        case .scale:
            return CGFloat(me) * UIScreen.main.bounds.size.width / DTB.Configuration.shared.designBaseSize.width
        }
    }
}

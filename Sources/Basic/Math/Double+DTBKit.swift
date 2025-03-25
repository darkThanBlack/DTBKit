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
extension DTBKitWrapper where Base: BinaryFloatingPoint {
    
    ///
    public func rounded(_ roundRule: FloatingPointRoundingRule? = nil) -> Self {
        if let rule = roundRule {
            return DTBKitWrapper(me.rounded(rule))
        }
        return DTBKitWrapper(me.rounded())
    }
}

/// String
///
/// 字符串处理。
extension DTBKitWrapper where Base: BinaryFloatingPoint {
    
    /// Convert to string.
    ///
    /// 转字符串。
    public func string() -> DTBKitWrapper<String> {
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
    public func nsDecimal() -> DTBKitWrapper<NSDecimalNumber>? {
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
    public func toString(_ formatter: NumberFormatter) -> DTBKitWrapper<String>? {
        return formatter.dtb.string(from: NSNumber(value: Double(me)))
    }
}

extension DTBKitWrapper where Base == Double {
    
    /// Cut dicimal places.
    ///
    /// 截取小数后 x 位。
    ///
    /// Example: ``1.26.dtb.place(1).value = 1.2``
    public func places(_ value: Int) -> Self {
        let div = pow(10.0, Double(value))
        return ((me * div).rounded(.down) / div).dtb
    }
}

/// High fidelity design
///
/// 高保真。
extension DTBKitWrapper where Base: BinaryFloatingPoint {
    
    public func hf(_ behavior: DTB.HFBehaviors = .scale) -> CGFloat {
        switch behavior {
        case .scale:
            return CGFloat(me) * UIScreen.main.bounds.size.width / DTB.Configuration.shared.designBaseSize.width
        }
    }
}

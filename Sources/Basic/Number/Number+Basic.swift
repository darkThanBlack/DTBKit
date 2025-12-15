//
//  DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2023/6/28
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import Foundation

//MARK: - Integer

extension Wrapper where Base: FixedWidthInteger & SignedInteger {
    
    /// Convert to NSDecimalNumber with behavior.
    ///
    /// 精度处理。
    @inline(__always)
    public func nsDecimal() -> Wrapper<NSDecimalNumber>? {
        let result = NSDecimalNumber(string: "\(me)")
        return result == NSDecimalNumber.notANumber ? nil : result.dtb
    }
    
    /// Convert to string.
    ///
    /// 转字符串。
    @inline(__always)
    public func string() -> Wrapper<String> {
        return "\(me)".dtb
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
        return Double(me).dtb.toString(formatter)
    }
}

//MARK: - Double

extension Wrapper where Base: BinaryFloatingPoint {
    
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
    
    /// Convert to string.
    ///
    /// 转字符串。
    @inline(__always)
    public func string() -> Wrapper<String> {
        return "\(me)".dtb
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

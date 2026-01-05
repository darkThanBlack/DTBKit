//
//  NumberFormatterUsage+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/18
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension Wrapper where Base: FixedWidthInteger & SignedInteger {
    
    @inline(__always)
    public func string(formatter: NumberFormatter) -> Wrapper<String>? {
        return toString(formatter)?.dtb
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
    public func toString(_ formatter: NumberFormatter) -> String? {
        return double().toString(formatter)
    }
}

extension Wrapper where Base: BinaryFloatingPoint {
    
    @inline(__always)
    public func string(formatter: NumberFormatter) -> Wrapper<String>? {
        return toString(formatter)?.dtb
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
    public func toString(_ formatter: NumberFormatter) -> String? {
        return formatter.string(from: nsNumber().value)
    }
}

extension Wrapper where Base == String {
    
    @inline(__always)
    public func toInt(_ formatter: NumberFormatter = DTB.config.numberFormatter) -> Int? {
        return formatter.number(from: me)?.intValue
    }
    
    @inline(__always)
    public func toInt64(_ formatter: NumberFormatter = DTB.config.numberFormatter) -> Int64? {
        return formatter.number(from: me)?.int64Value
    }
    
    @inline(__always)
    public func toDouble(_ formatter: NumberFormatter = DTB.config.numberFormatter) -> Double? {
        return formatter.number(from: me)?.doubleValue
    }
    
}

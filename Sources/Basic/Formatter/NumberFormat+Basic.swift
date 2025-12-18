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

extension Wrapper where Base: BinaryFloatingPoint {
    
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
        return formatter.dtb.string(from: NSNumber(value: doubleValue()))
    }
}

extension Wrapper where Base == String {
    
    @inline(__always)
    public func toInt(_ formatter: NumberFormatter = DTB.config.numberFormatter) -> Wrapper<Int>? {
        return formatter.dtb.number(from: me)?.int()
    }
    
    @inline(__always)
    public func toInt64(_ formatter: NumberFormatter = DTB.config.numberFormatter) -> Wrapper<Int64>? {
        return formatter.dtb.number(from: me)?.int64()
    }
    
    @inline(__always)
    public func toDouble(_ formatter: NumberFormatter = DTB.config.numberFormatter) -> Wrapper<Double>? {
        return formatter.dtb.number(from: me)?.double()
    }
    
}

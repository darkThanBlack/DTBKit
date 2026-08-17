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
    /// 格式化字符串；返回 wrapper, 便于链式。
    @inline(__always)
    public func string(formatter: DTB.NumberFormatterConfig) -> Wrapper<String>? {
        return toString(formatter)?.dtb
    }
    
    /// Convert to string with numberFormatter.
    ///
    /// 格式化字符串。直接返回字符串，便于使用。
    ///
    /// e.g.
    /// ```
    ///     let a = 2.1.dtb.toString(.dtb.CNY())
    /// ```
    @inline(__always)
    public func toString(_ formatter: DTB.NumberFormatterConfig) -> String? {
        return double().toString(formatter)
    }
}

extension Wrapper where Base: BinaryFloatingPoint {
    
    /// Convert to string with numberFormatter.
    ///
    /// 格式化字符串；返回 wrapper, 便于链式。
    @inline(__always)
    public func string(formatter: DTB.NumberFormatterConfig) -> Wrapper<String>? {
        return toString(formatter)?.dtb
    }
    
    /// Convert to string with numberFormatter.
    ///
    /// 格式化字符串。直接返回字符串，便于使用。
    ///
    /// e.g.
    /// ```
    ///     let a = 2.1.dtb.toString(.dtb.CNY())
    /// ```
    @inline(__always)
    public func toString(_ formatter: DTB.NumberFormatterConfig) -> String? {
        return formatter.string(from: nsNumber().value)
    }
}

extension Wrapper where Base == String {
    
    @inline(__always)
    public func number(formatter: DTB.NumberFormatterConfig) -> Wrapper<NSNumber>? {
        return toNumber(formatter)?.dtb
    }
    
    @inline(__always)
    public func toNumber(_ formatter: DTB.NumberFormatterConfig) -> NSNumber? {
        return formatter.number(from: me)
    }
    
}

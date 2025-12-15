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
    
    /// Specified type.
    @inline(__always)
    public func intValue() -> Int {
        return Int(me)
    }
    
    /// Specified type.
    @inline(__always)
    public func int64Value() -> Int64 {
        return Int64(me)
    }
    
    /// Force convert
    @inline(__always)
    public func double() -> Wrapper<Double> {
        return Double(me).dtb
    }
    
    @inline(__always)
    public func nsNumber() -> Wrapper<NSNumber> {
        return NSNumber(value: intValue()).dtb
    }
    
    /// Ignore ``notANumber``.
    @inline(__always)
    public func nsDecimal() -> Wrapper<NSDecimalNumber> {
        return NSDecimalNumber(value: intValue()).dtb
    }
    
    /// ``"\(me)"``
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
    
    /// Specified type.
    @inline(__always)
    public func doubleValue() -> Double {
        return Double(me)
    }
    
    /// Specified type.
    @inline(__always)
    public func cgFloatValue() -> CGFloat {
        return CGFloat(me)
    }
    
    /// Force convert with ``Int(me)``.
    @inline(__always)
    public func int() -> Wrapper<Int> {
        return Int(doubleValue()).dtb
    }
    
    /// Force convert with ``Int64(me)``.
    @inline(__always)
    public func int64() -> Wrapper<Int64> {
        return Int64(doubleValue()).dtb
    }
    
    @inline(__always)
    public func rounded(_ roundRule: FloatingPointRoundingRule? = nil) -> Self {
        if let rule = roundRule {
            return Wrapper(me.rounded(rule))
        }
        return Wrapper(me.rounded())
    }
    
    @inline(__always)
    public func nsNumber() -> Wrapper<NSNumber> {
        return NSNumber(value: doubleValue()).dtb
    }
    
    /// Ignore ``notANumber``.
    @inline(__always)
    public func nsDecimal() -> Wrapper<NSDecimalNumber> {
        return NSDecimalNumber(value: doubleValue()).dtb
    }
    
    /// ``"\(me)"``
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
        return formatter.dtb.string(from: NSNumber(value: doubleValue()))
    }
    
}

//MARK: - String

extension Wrapper where Base == String {
    
    /// Force convert.
    ///
    /// Note:
    /// ```
    /// Int64("1.23")  // nil
    /// "1.23".dtb.int64()?.value  // 1
    /// ```
    @inline(__always)
    public func int() -> Wrapper<Int>? {
        return double()?.int()
    }
    
    /// Force convert.
    ///
    /// Note:
    /// ```
    /// Int64("1.23")  // nil
    /// "1.23".dtb.int64()?.value  // 1
    /// ```
    @inline(__always)
    public func int64() -> Wrapper<Int64>? {
        return double()?.int64()
    }
    
    /// Force convert.
    @inline(__always)
    public func double() -> Wrapper<Double>? {
        return Double(me)?.dtb
    }
    
    @inline(__always)
    public func nsNumber() -> Wrapper<NSNumber>? {
        if let v = Double(me) {
            return NSNumber(value: v).dtb
        }
        return nil
    }
    
    /// Return ``nil`` when notANumber.
    @inline(__always)
    public func nsDecimal() -> Wrapper<NSDecimalNumber>? {
        let result = NSDecimalNumber(string: me)
        return result == NSDecimalNumber.notANumber ? nil : result.dtb
    }
    
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

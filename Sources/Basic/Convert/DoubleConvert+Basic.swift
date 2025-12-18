//
//  DoubleConvert+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/18
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

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

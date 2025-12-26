//
//  StringConvert+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/18
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

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
        return Int(me)?.dtb
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
        return Int64(me)?.dtb
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
    
    @inline(__always)
    public func nsDecimal() -> Wrapper<NSDecimalNumber> {
        return NSDecimalNumber(string: me).dtb
    }
    
    /// From 's' timeStamp (length == 10) | 从 10 位秒级时间戳生成
    @inline(__always)
    public func sDate() -> Wrapper<Date>? {
        return Date.dtb.create(s: me)?.dtb
    }
    
    /// From 'ms' timeStamp (length == 13) | 从 13 位毫秒级时间戳生成
    @inline(__always)
    public func msDate() -> Wrapper<Date>? {
        return Date.dtb.create(ms: me)?.dtb
    }
    
}

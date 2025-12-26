//
//  IntegerConvert+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/18
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import Foundation

/// Convert type to another with default behavior.
extension Wrapper where Base: FixedWidthInteger & SignedInteger {
    
    // MARK: - 
    
    @inline(__always)
    public func intValue() -> Int {
        return Int(me)
    }
    
    @inline(__always)
    public func int64Value() -> Int64 {
        return Int64(me)
    }
    
    // MARK: - Force convert
    
    /// Force convert
    @inline(__always)
    public func double() -> Wrapper<Double> {
        return Double(me).dtb
    }
    
    @inline(__always)
    public func nsNumber() -> Wrapper<NSNumber> {
        return NSNumber(value: intValue()).dtb
    }
    
    @inline(__always)
    public func nsDecimal() -> Wrapper<NSDecimalNumber> {
        return NSDecimalNumber(value: intValue()).dtb
    }
    
    /// ``"\(me)"``
    @inline(__always)
    public func string() -> Wrapper<String> {
        return "\(me)".dtb
    }
    
    // MARK: - Date
    
    /// From 's' timeStamp (length == 10) | 从 10 位秒级时间戳生成
    @inline(__always)
    public func sDate() -> Wrapper<Date> {
        return Date.dtb.create(s: me).dtb
    }
    
    /// From 'ms' timeStamp (length == 13) | 从 13 位毫秒级时间戳生成
    @inline(__always)
    public func msDate() -> Wrapper<Date> {
        return Date.dtb.create(ms: me).dtb
    }
    
}

//
//  Int+XMKit.swift
//  XMKit_Example
//
//  Created by moonShadow on 2023/8/29
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import Foundation

extension Int: DTBKitStructable {}

extension Int8: DTBKitStructable {}

extension Int16: DTBKitStructable {}

extension Int32: DTBKitStructable {}

extension Int64: DTBKitStructable {}


/// String
///
/// 字符串处理。
extension DTBKitWrapper where Base: FixedWidthInteger & SignedInteger {
    
    /// From 's' timeStamp (length == 10) | 从 10 位秒级时间戳生成
    @inline(__always)
    public var sDate: DTBKitWrapper<Date>? {
        return Date.dtb.create(s: Int64(me))?.dtb
    }
    
    /// From 'ms' timeStamp (length == 13) | 从 13 位毫秒级时间戳生成
    @inline(__always)
    public var msDate: DTBKitWrapper<Date>? {
        return Date.dtb.create(ms: Int64(me))?.dtb
    }
    
    /// Convert to string.
    ///
    /// 转字符串。
    @inline(__always)
    public var string: DTBKitWrapper<String> {
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
    public func toString(_ formatter: NumberFormatter) -> DTBKitWrapper<String>? {
        return Double(me).dtb.toString(formatter)
    }
    
    /// Convert to NSDecimalNumber with behavior.
    ///
    /// 精度处理。
    @inline(__always)
    public var nsDecimal: DTBKitWrapper<NSDecimalNumber>? {
        let result = NSDecimalNumber(string: "\(me)")
        return result == NSDecimalNumber.notANumber ? nil : result.dtb
    }
}

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

///
extension DTBKitWrapper where Base: SignedInteger {
    
    ///
    public func toDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(me / 1000))
    }
}

/// String
///
/// 字符串处理。
extension DTBKitWrapper where Base: SignedInteger {
    
    /// Convert to string.
    ///
    /// 转字符串。
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
    public func toString(_ formatter: NumberFormatter) -> DTBKitWrapper<String>? {
        return Double(me).dtb.toString(formatter)
    }
    
    /// Convert to NSDecimalNumber with behavior.
    ///
    /// 精度处理。
    public var nsDecimal: DTBKitWrapper<NSDecimalNumber> {
        return NSDecimalNumber(string: "\(me)").dtb
    }
}

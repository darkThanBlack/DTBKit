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

extension DTB.Wrapper where Base == String {
    
    /// Force convert.
    ///
    /// Note:
    /// ```
    /// Int64("1.23")  // nil
    /// "1.23".dtb.int64()?.value  // 1
    /// ```
    @inline(__always)
    public func int() -> DTB.Wrapper<Int>? {
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
    public func int64() -> DTB.Wrapper<Int64>? {
        return Int64(me)?.dtb
    }
    
    /// Force convert.
    @inline(__always)
    public func double() -> DTB.Wrapper<Double>? {
        return Double(me)?.dtb
    }
    
    /// Convert to ``NSString``.
    @inline(__always)
    public func ns() -> DTB.Wrapper<NSString> {
        return NSString(string: me).dtb
    }
    
    @inline(__always)
    public func nsNumber() -> DTB.Wrapper<NSNumber>? {
        if let v = Double(me) {
            return NSNumber(value: v).dtb
        }
        return nil
    }
    
    @inline(__always)
    public func nsDecimal() -> DTB.Wrapper<NSDecimalNumber> {
        return NSDecimalNumber(string: me).dtb
    }
    
    /// From 's' timeStamp (length == 10) | 从 10 位秒级时间戳生成
    @inline(__always)
    public func sDate() -> DTB.Wrapper<Date>? {
        return Date.dtb(s: me)?.dtb
    }
    
    /// From 'ms' timeStamp (length == 13) | 从 13 位毫秒级时间戳生成
    @inline(__always)
    public func msDate() -> DTB.Wrapper<Date>? {
        return Date.dtb(ms: me)?.dtb
    }
    
    /// Convert to ``NSMutableAttributedString``.
    @inline(__always)
    public func attr() -> DTB.Wrapper<NSMutableAttributedString> {
        return NSMutableAttributedString(string: me).dtb
    }
    
}

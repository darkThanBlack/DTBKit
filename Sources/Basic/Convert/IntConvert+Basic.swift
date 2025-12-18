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
    
    /// From 's' timeStamp (length == 10) | 从 10 位秒级时间戳生成
    @inline(__always)
    public func sDate() -> Wrapper<Date>? {
        return Date.dtb.create(s: Int64(me))?.dtb
    }
    
    /// From 'ms' timeStamp (length == 13) | 从 13 位毫秒级时间戳生成
    @inline(__always)
    public func msDate() -> Wrapper<Date>? {
        return Date.dtb.create(ms: Int64(me))?.dtb
    }
    
}

/// FIXME
extension Wrapper where Base: FixedWidthInteger & SignedInteger {

    
    /// 分钟数转 "HH:mm" 形式, "00:00"
    @inline(__always)
    public func minutesString() -> String {
        return String(format: "%02d:%02d", Int(me) / 60, Int(me) % 60)
    }
    
    /// 将数字转换为星期名称
    ///
    /// - Parameter type: 是否使用 ISO 8601 标准 (数字1 对应周一还是周日)
    /// - Returns: 本地化的星期名称
    @inline(__always)
    public func weekDayString(_ type: DTB.WeekdayTypes = .iso) -> String? {
        switch type {
        case .iso:
            return [
                1: "周一", 2: "周二", 3: "周三", 4: "周四", 5: "周五", 6: "周六", 7: "周日"
            ][me]
        case .gregorian:
            return [
                1: "周日", 2: "周一", 3: "周二", 4: "周三", 5: "周四", 6: "周五", 7: "周六"
            ][me]
        }
    }
}

//
//  Int+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/29
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import Foundation

/// String
///
/// 字符串处理。
extension Wrapper where Base: FixedWidthInteger & SignedInteger {
    
    /// Convert to string.
    ///
    /// 转字符串。
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
    
    /// Convert to NSDecimalNumber with behavior.
    ///
    /// 精度处理。
    @inline(__always)
    public func nsDecimal() -> Wrapper<NSDecimalNumber>? {
        let result = NSDecimalNumber(string: "\(me)")
        return result == NSDecimalNumber.notANumber ? nil : result.dtb
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

extension DTB {
    /// 星期名称规范
    public enum WeekdayTypes {
        /// ISO 8601: 周一=1, 周日=7 (欧洲、中国等)
        case iso
        /// 公历: 周日=1, 周六=7 (北美等)
        case gregorian
    }
}

/// Time
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

//
//  Duration+Basic.swift
//  DTBKit_Basic
//
//  Created by moonShadow on 2026/1/6
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

// FIXME: 非标格式，重构中

extension DTB {
    /// 星期名称规范
    public enum WeekdayTypes {
        /// ISO 8601: 周一=1, 周日=7 (欧洲、中国等)
        case iso
        /// 公历: 周日=1, 周六=7 (北美等)
        case gregorian
    }
}

extension DTB {
    
    /// 时长字符串转换
    public enum DateDurationFormatTypes {
        /// "12时33分28秒", "4分6秒"
        case text
        /// 12'33", 6"
        case symbol
    }
}

extension Wrapper where Base == Date {
    
    /// 计算从 startOfDay 到 当前 经过的分钟数
    public func dayMinutes() -> Wrapper<Int64>? {
        guard let myStartDayMs = startOfDay()?.ms().value else {
            return nil
        }
        return ((ms().value - myStartDayMs) / 60).dtb
    }
}

extension Wrapper where Base: FixedWidthInteger & SignedInteger {
    
    /// s -> ms, me * 1000
    public func toMS() -> Wrapper<Double> {
        return (Double(me) * 1000).dtb
    }
    
    /// ms -> s, me / 1000
    public func toS() -> Wrapper<Double> {
        return (Double(me) / 1000).dtb
    }
    
    /// 根据毫秒时间戳转换为可读的时长字符串
    public func toDurationString(_ type: DTB.DateDurationFormatTypes) -> String? {
        let seconds = me / 1000
        let minutes = seconds / 60
        let hours = minutes / 60
        
        switch type {
        case .text:
            if hours > 0 {
                return "\(hours)小时\(minutes % 60)分"
            } else if minutes > 0 {
                return "\(minutes % 60)分\(seconds % 60)秒"
            } else {
                return "\(seconds % 60)秒"
            }
        case .symbol:
            if minutes > 0 {
                return "\(minutes)\'\(seconds % 60)\""
            } else {
                return "\(seconds % 60)\""
            }
        }
    }
    
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

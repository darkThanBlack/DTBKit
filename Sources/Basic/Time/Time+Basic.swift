//
//  Date+DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2024/10/16
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

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
    
    /// Custom date dynamic format rule | 自定义动态(分段)转换规则
    ///
    /// More details in ``Explain.md``
    public struct DateDynamicBarrierItem {
        
        public let mapper: ((_ base: Date, _ to: Date) -> String?)
    }
    
    /// 时长字符串转换
    public enum DateDurationFormatTypes {
        /// "12时33分28秒", "4分6秒"
        case text
        /// 12'33", 6"
        case symbol
    }
}

extension DTB.DateDynamicBarrierItem {
    
    /// 早于当前日期
    public static func negative(_ format: String = "yyyy-MM-dd HH:mm") -> Self {
        return .init { base, to in
            let delta = base.timeIntervalSince1970 - to.timeIntervalSince1970
            return delta < 0 ? to.dtb.formatString(format) : nil
        }
    }
    
    /// 一分钟内 | "刚刚"
    public static func oneMinute() -> Self {
        return .init { base, to in
            let delta = base.timeIntervalSince1970 - to.timeIntervalSince1970
            return delta < 60 ? "刚刚" : nil
        }
    }
    
    /// 一小时内 | "x分钟前"
    public static func oneHour() -> Self {
        return .init { base, to in
            let delta = base.timeIntervalSince1970 - to.timeIntervalSince1970
            return delta < 3600 ? "\(Int(delta / 60))分钟前" : nil
        }
    }
    
    /// 今天 | "今天 HH:mm"
    public static func today(_ format: String = "HH:mm") -> Self {
        return .init { base, to in
            return to.dtb.isSameDay(base) ? "今天 \(to.dtb.formatString(format))" : nil
        }
    }
    
    /// 昨天 | "昨天 HH:mm"
    public static func yesterday(_ format: String = "HH:mm") -> Self {
        return .init { base, to in
            return to.dtb.isSameDay(base.dtb.addingDay(-1)?.value) ? "昨天 \(to.dtb.formatString(format))" : nil
        }
    }
    
    /// 明天 | "明天 HH:mm"
    public static func tomorrow(_ format: String = "HH:mm") -> Self {
        return .init { base, to in
            return to.dtb.isSameDay(base.dtb.addingDay(1)?.value) ? "明天 \(to.dtb.formatString(format))" : nil
        }
    }
    
    /// 同一年 | "MM月dd日 EEE HH:mm"
    public static func sameYear(_ format: String = "MM-dd HH:mm") -> Self {
        return .init { base, to in
            return to.dtb.isSameYear(base) ? to.dtb.formatString(format) : nil
        }
    }
    
    /// 其他情况兜底 | "yyyy-MM-dd HH:mm"
    public static func another(_ format: String = "yyyy-MM-dd HH:mm") -> Self {
        return .init { _, to in
            return to.dtb.formatString(format)
        }
    }
}

extension Wrapper where Base == Date {
    
    /// Dynamic format string | 动态(分段)时间转换
    ///
    /// Defaults result like:
    /// ```
    /// 刚刚
    /// 3分钟前
    /// 今天 16:59
    /// 昨天 18:06
    /// 10-09 18:06
    /// ```
    /// More details in ``Explain.md``.
    ///
    /// - Note: Your custom barrier must cover all situations.
    /// - Parameters:
    ///   - barrier:
    ///     Mapping relationship from the past to the future |
    ///     按从过去到未来顺序的时间-字符串映射关系
    ///   - baseOn:
    ///     Time axis origin |
    ///     时间坐标轴原点
    /// - Returns:
    ///     Dynamic string depending on time |
    ///     按规则返回不同样式的字符串
    public func toDynamic(
        _ barrier: [DTB.DateDynamicBarrierItem] = [
            .negative(),
            .oneMinute(),
            .oneHour(),
            .today(),
            .yesterday(),
            .tomorrow(),
            .sameYear(),
            .another()
        ],
        baseOn: Date = Date()
    ) -> String {
        return barrier.first(where: { $0.mapper(baseOn, me) != nil })?.mapper(Date(), me) ?? {
#if DEBUG
            assert(false)
#endif
            return formatString()
        }()
    }
    
    /// 计算从 startOfDay 到 当前 经过的分钟数
    public func dayMinutes() -> Wrapper<Int64>? {
        guard let myStartDayMs = startOfDay()?.ms().value else {
            return nil
        }
        return ((ms().value - myStartDayMs) / 60).dtb
    }
    
    /// 根据毫秒时间戳转换为可读的时长字符串
    public func toDuration(_ type: DTB.DateDurationFormatTypes) -> String? {
        let seconds = ms().value / 1000
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
    
    // MARK: - Calendar
    
    /// Self - date | 日期差值
    @inline(__always)
    public func delta(to date: Date, _ unit: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([unit], from: date, to: me).value(for: unit)
    }
    
    /// Use current calendar to check self is same unit by date | 是否为同一 "unit", 注意一般需从年往下逼近判断
    public func same(to date: Date?, _ unit: Set<Calendar.Component>) -> Bool {
        guard let d = date else { return false }
        let l1 = Calendar.current.dateComponents(unit, from: d)
        let l2 = Calendar.current.dateComponents(unit, from: me)
        return unit.allSatisfy { l1.value(for: $0) == l2.value(for: $0) }
    }
    
    /// 是否为同一天
    @inline(__always)
    public func isSameDay(_ date: Date? = Date()) -> Bool {
        return same(to: date, [.day, .month, .year])
    }
    
    /// 是否为同一月
    @inline(__always)
    public func isSameMonth(_ date: Date? = Date()) -> Bool {
        return same(to: date, [.month, .year])
    }
    
    /// 是否为同一年
    @inline(__always)
    public func isSameYear(_ date: Date? = Date()) -> Bool {
        return same(to: date, [.year])
    }
    
    // FIXME: DateComponents
    
    /// extension Get dateComponents by Calendar.current | 自由取值
    public func dateComponents(_ units: Set<Calendar.Component>) -> DateComponents {
        return Calendar.current.dateComponents(units, from: me)
    }
    
    /// Get components value by Calendar.current | 自由取值
//    public func dateComponentsValue(for unit: Calendar.Component) -> Wrapper<Int>? {
//        return Calendar.current.dateComponents([unit], from: me).value(for: unit)?.dtb
//    }
    
    /// Adding components value by Calendar.current | 自由增减
    @inline(__always)
    public func adding(by components: DateComponents) -> Self? {
        return Calendar.current.date(byAdding: components, to: me)?.dtb
    }
    
    /// Adding components value by Calendar.current | 自由增减
    @inline(__always)
    public func adding(_ value: Int, unit: Calendar.Component) -> Self? {
        return adding(by: {
            var components = DateComponents()
            components.setValue(value, for: unit)
            return components
        }())
    }
    
    /// 增减天数
    @inline(__always)
    public func addingDay(_ days: Int) -> Self? {
        return adding(days, unit: .day)
    }
    
    /// 增减周数
    @inline(__always)
    public func addingWeek(_ weeks: Int) -> Self? {
        return adding(weeks, unit: .weekOfYear)
    }
    
    /// 增减月份
    @inline(__always)
    public func addingMonth(_ months: Int) -> Self? {
        return adding(months, unit: .month)
    }
    
    /// 增减年
    @inline(__always)
    public func addingYear(_ years: Int) -> Self? {
        return adding(years, unit: .year)
    }
    
    /// 当年第一天
    @inline(__always)
    public func startOfYear() -> Self? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: me))?.dtb
    }
    
    /// 当月第一天
    @inline(__always)
    public func startOfMonth() -> Self? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: me))?.dtb
    }
    
    /// 当周第一天
    public func startOfWeek() -> Self? {
        /// 每周的第一天改为周一
        let C = {
            var c = Calendar.current
            c.firstWeekday = 2
            return c
        }()
        guard let now = C.component(.weekday, from: me) == 1 ? me.dtb.addingDay(-1)?.value : me else {
            return nil
        }
        return C.date(from: C.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))?.dtb
    }
    
    /// 当天第一秒
    public func startOfDay() -> Self? {
        return Calendar.current.date(from: {
            var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: me)
            components.hour = 0
            components.minute = 0
            components.second = 0
            return components
        }())?.dtb
    }
    
    /// 当年最后一天
    @inline(__always)
    public func endOfYear() -> Self? {
        return startOfYear()?.adding(by: DateComponents(year: 1, second: -1))
    }
    
    /// 当月最后一天
    @inline(__always)
    public func endOfMonth() -> Self? {
        return startOfMonth()?.adding(by: DateComponents(month: 1, second: -1))
    }
    
    /// 当周最后一天
    @inline(__always)
    public func endOfWeek() -> Self? {
        return startOfWeek()?.adding(by: DateComponents(day: 7, second: -1))
    }
    
    /// 当天最后一秒
    public func endOfDay() -> Self? {
        return Calendar.current.date(from: {
            var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: me)
            components.hour = 23
            components.minute = 59
            components.second = 59
            return components
        }())?.dtb
    }
}

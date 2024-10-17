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

extension DTBKitStaticWrapper where T == Date {
    
    /// From timeStamp(ms, length == 13) | 从 13 位毫秒时间戳生成
    func create(ms: Int64?) -> T {
        guard let t = ms, String(t).count == 13 else {
            return Date()
        }
        return Date(timeIntervalSince1970: TimeInterval(t / 1000))
    }
}

extension DTBKitWrapper where Base == Date {
    
    /// Get Int64 by .timeIntervalSince1970
    public func s() -> Int64 {
        return Int64(me.timeIntervalSince1970)
    }
    
    /// Get timeStamp(ms, length == 13) | 获取 13 位毫秒时间戳
    public func ms() -> Int64 {
        return Int64(me.timeIntervalSince1970 * 1000)
    }
    
    ///
    public func toString(_ formatter: @autoclosure (() -> DateFormatter)) -> DTBKitWrapper<String> {
        return formatter().string(from: me).dtb
    }
    
    ///
    public func format(_ str: String = "yyyy-MM-dd HH:mm") -> String {
        return DateFormatter().dtb.dateFormat(str).value.string(from: me)
    }
    
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
    /// More details in ``dtbkit_explain.md``.
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
            .oneMinute,
            .oneHour,
            .today(),
            .yesterday(),
            .tomorrow(),
            .sameYear(),
            .another()
        ],
        baseOn: Date = Date()
    ) -> String {
        return barrier.first(where: { $0.mapper(baseOn, me) != nil })?.mapper(Date(), me) ?? {
            assert(false)
            return ""
        }()
    }
    
    // MARK: - Calendar
    
    /// Self - date | 日期差值
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
    public func isSameDay(_ date: Date? = Date()) -> Bool {
        return same(to: date, [.day, .month, .year])
    }
    
    /// 是否为同一月
    public func isSameMonth(_ date: Date? = Date()) -> Bool {
        return same(to: date, [.month, .year])
    }
    
    /// 是否为同一年
    public func isSameYear(_ date: Date? = Date()) -> Bool {
        return same(to: date, [.year])
    }
    
    /// Get components value by current calendar | 自由取值
    public func value(for unit: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([unit], from: me).value(for: unit)
    }
    
    /// Adding components value by current calendar | 自由增减
    public func adding(_ value: Int, unit: Calendar.Component) -> Self? {
        var components = DateComponents()
        components.setValue(value, for: unit)
        return Calendar.current.date(byAdding: components, to: me)?.dtb
    }
    
    /// 增减天数
    public func addingDay(_ days: Int) -> Self? {
        return adding(days, unit: .day)
    }
    
    /// 增减周数
    public func addingWeek(_ weeks: Int) -> Self? {
        return adding(weeks, unit: .weekOfYear)
    }
    
    /// 增减月份
    public func addingMonth(_ months: Int) -> Self? {
        return adding(months, unit: .month)
    }
    
    /// 增减年
    public func addingYear(_ years: Int) -> Self? {
        return adding(years, unit: .year)
    }
}

extension DTB {
    
    /// Custom date dynamic format rule | 自定义动态(分段)转换规则
    ///
    /// More details in ``dtbkit_explain.md``
    public struct DateDynamicBarrierItem {
        
        public let mapper: ((_ base: Date, _ to: Date) -> String?)
    }
}

extension DTB.DateDynamicBarrierItem {
    
    /// 早于当前日期
    public static func negative(_ format: String = "yyyy-MM-dd HH:mm") -> Self {
        return .init { base, to in
            let delta = base.timeIntervalSince1970 - to.timeIntervalSince1970
            return delta < 0 ? to.dtb.format(format) : nil
        }
    }
    
    /// 一分钟内 | "刚刚"
    public static let oneMinute = Self { base, to in
        let delta = base.timeIntervalSince1970 - to.timeIntervalSince1970
        return delta < 60 ? "刚刚" : nil
    }
    
    /// 一小时内 | "x分钟前"
    public static let oneHour = Self { base, to in
        let delta = base.timeIntervalSince1970 - to.timeIntervalSince1970
        return delta < 3600 ? "\(Int(delta / 60))分钟前" : nil
    }
    
    /// 今天 | "今天 HH:mm"
    public static func today(_ format: String = "HH:mm") -> Self {
        return .init { base, to in
            return to.dtb.isSameDay(base) ? "今天 \(to.dtb.format(format))" : nil
        }
    }
    
    /// 昨天 | "昨天 HH:mm"
    public static func yesterday(_ format: String = "HH:mm") -> Self {
        return .init { base, to in
            return to.dtb.isSameDay(base.dtb.addingDay(-1)) ? "昨天 \(to.dtb.format(format))" : nil
        }
    }
    
    /// 明天 | "明天 HH:mm"
    public static func tomorrow(_ format: String = "HH:mm") -> Self {
        return .init { base, to in
            return to.dtb.isSameDay(base.dtb.addingDay(1)) ? "明天 \(to.dtb.format("HH:mm"))" : nil
        }
    }
    
    /// 同一年 | "MM月dd日 EEE HH:mm"
    public static func sameYear(_ format: String = "MM-dd HH:mm") -> Self {
        return .init { base, to in
            return to.dtb.isSameYear(base) ? to.dtb.format("MM-dd HH:mm") : nil
        }
    }
    
    /// 其他情况兜底 | "yyyy-MM-dd HH:mm"
    public static func another(_ format: String = "yyyy-MM-dd HH:mm") -> Self {
        return .init { _, to in
            return to.dtb.format(format)
        }
    }
}

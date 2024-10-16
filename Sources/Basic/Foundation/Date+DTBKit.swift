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
    
    /// Get timeStamp(ms, length == 13) | 获取 13 位毫秒时间戳
    public func ms() -> Int64 {
        return Int64(me.timeIntervalSince1970 * 1000)
    }
    
    ///
    public func format(_ str: String = "yyyy-MM-dd HH:mm") -> String {
        return DateFormatter().dtb.dateFormat(str).value.string(from: me)
    }
    
    /// 动态(分段)时间转换
    ///
    /// Example in Uni-Test
    /// More details in ``dtbkit_explain.md``
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
    
    ///
    public func toString(_ formatter: @autoclosure (() -> DateFormatter)) -> DTBKitWrapper<String> {
        return formatter().string(from: me).dtb
    }
    
    /// 是否为同一天
    public func isSameDay(_ date: Date = Date()) -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day, .month, .year]
        let dateComponents = calendar.dateComponents(unit, from: date)
        let selfComponents = calendar.dateComponents(unit, from: me)
        
        return (dateComponents.year == selfComponents.year) &&
            (dateComponents.month == selfComponents.month) &&
            (dateComponents.day == selfComponents.day)
    }
    
    /// 是否为同一月
    public func isSameMonth(_ date: Date = Date()) -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.month, .year]
        let dateComponents = calendar.dateComponents(unit, from: date)
        let selfComponents = calendar.dateComponents(unit, from: me)
        
        return (dateComponents.year == selfComponents.year) &&
            (dateComponents.month == selfComponents.month)
    }
    
    /// 是否为同一年
    public func isSameYear(_ date: Date = Date()) -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.year]
        let dateComponents = calendar.dateComponents(unit, from: date)
        let selfComponents = calendar.dateComponents(unit, from: me)
        
        return dateComponents.year == selfComponents.year
    }
    
    /// 当前日期上增减天数
    public func plusDay(_ days: Int) -> Date {
        var components = DateComponents()
        components.day = days
        let date = Calendar.current.date(byAdding: components, to: me)
        return date ?? Date()
    }
    
    /// 当前日期上增减周数
    public func plusWeek(_ weeks: Int) -> Date {
        var components = DateComponents()
        components.weekOfYear = weeks
        let date = Calendar.current.date(byAdding: components, to: me)
        return date ?? Date()
    }
    
    /// 当前日期上增减月份
    public func plusMonth(_ months: Int) -> Date {
        var components = DateComponents()
        components.month = months
        let date = Calendar.current.date(byAdding: components, to: me)
        return date ?? Date()
    }
    
    /// 当前日期上增减年
    public func plusYear(_ years: Int) -> Date {
        var components = DateComponents()
        components.year = years
        let date = Calendar.current.date(byAdding: components, to: me)
        return date ?? Date()
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
            return delta < 0 ? to.dtb.format() : nil
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
            return to.dtb.isSameDay(base.dtb.plusDay(-1)) ? "昨天 \(to.dtb.format(format))" : nil
        }
    }
    
    /// 明天 | "明天 HH:mm"
    public static func tomorrow(_ format: String = "HH:mm") -> Self {
        return .init { base, to in
            return to.dtb.isSameDay(base.dtb.plusDay(1)) ? "明天 \(to.dtb.format("HH:mm"))" : nil
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

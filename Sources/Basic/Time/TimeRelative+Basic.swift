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
    
    /// Custom date dynamic format rule | 自定义动态(分段)转换规则
    ///
    /// More details in ``Explain.md``
    public struct DateRelativeRule {
        
        public let mapper: ((_ base: Date, _ to: Date) -> String?)
    }
}

extension DTB.DateRelativeRule {
    
    /// 默认规则
    ///
    /// Defaults result like:
    /// ```
    /// 刚刚
    /// 3分钟前
    /// 今天 16:59
    /// 昨天 18:06
    /// 10-09 18:06
    /// ```
    public static func defRules() -> [Self] {
        return [
            .negative(),
            .oneMinute(),
            .oneHour(),
            .today(),
            .yesterday(),
            .tomorrow(),
            .sameYear(),
            .another()
        ]
    }
    
    /// 早于当前日期
    public static func negative(_ format: String = "yyyy-MM-dd HH:mm") -> Self {
        return .init { base, to in
            let delta = base.timeIntervalSince1970 - to.timeIntervalSince1970
            return delta < 0 ? to.dtb.toString(format) : nil
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
            return to.dtb.isSameDay(base) ? "今天 \(to.dtb.toString(format))" : nil
        }
    }
    
    /// 昨天 | "昨天 HH:mm"
    public static func yesterday(_ format: String = "HH:mm") -> Self {
        return .init { base, to in
            return to.dtb.isSameDay(base.dtb.addingDay(-1)?.value) ? "昨天 \(to.dtb.toString(format))" : nil
        }
    }
    
    /// 明天 | "明天 HH:mm"
    public static func tomorrow(_ format: String = "HH:mm") -> Self {
        return .init { base, to in
            return to.dtb.isSameDay(base.dtb.addingDay(1)?.value) ? "明天 \(to.dtb.toString(format))" : nil
        }
    }
    
    /// 同一年 | "MM月dd日 EEE HH:mm"
    public static func sameYear(_ format: String = "MM-dd HH:mm") -> Self {
        return .init { base, to in
            return to.dtb.isSameYear(base) ? to.dtb.toString(format) : nil
        }
    }
    
    /// 其他情况兜底 | "yyyy-MM-dd HH:mm"
    public static func another(_ format: String = "yyyy-MM-dd HH:mm") -> Self {
        return .init { _, to in
            return to.dtb.toString(format)
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
    ///   - baseDate:
    ///     Time axis origin |
    ///     时间坐标轴原点
    /// - Returns:
    ///     Dynamic string depending on time |
    ///     按规则返回不同样式的字符串
    public func toRelativeString(
        barrier: [DTB.DateRelativeRule] = DTB.DateRelativeRule.defRules(),
        baseDate: Date = Date()
    ) -> String {
        return barrier.first(where: { $0.mapper(baseDate, me) != nil })?.mapper(baseDate, me) ?? {
#if DEBUG
            DTB.console.fail("Barrier missing this date: \(me)")
#endif
            return toString()
        }()
    }
}

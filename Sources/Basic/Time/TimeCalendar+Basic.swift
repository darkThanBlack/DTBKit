//
//  Calendar+Basic.swift
//  DTBKit_Basic
//
//  Created by moonShadow on 2026/1/6
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base == Date {
    
    /// Self - date | 日期差值
    @inline(__always)
    public func minus(to date: Date, _ unit: Calendar.Component) -> Wrapper<Int>? {
        return Calendar.current.dateComponents([unit], from: date, to: me).value(for: unit)?.dtb
    }
    
    /// Use current calendar to check self is same unit by date | 是否为同一 "unit", 注意一般需从年往下逼近判断
    @inline(__always)
    public func isSame(to date: Date?, _ unit: Set<Calendar.Component>) -> Bool {
        guard let d = date else { return false }
        let l1 = Calendar.current.dateComponents(unit, from: d)
        let l2 = Calendar.current.dateComponents(unit, from: me)
        return unit.allSatisfy { l1.value(for: $0) == l2.value(for: $0) }
    }
    
    /// 是否为同一天
    @inline(__always)
    public func isSameDay(_ date: Date? = Date()) -> Bool {
        return isSame(to: date, [.day, .month, .year])
    }
    
    /// 是否为同一月
    @inline(__always)
    public func isSameMonth(_ date: Date? = Date()) -> Bool {
        return isSame(to: date, [.month, .year])
    }
    
    /// 是否为同一年
    @inline(__always)
    public func isSameYear(_ date: Date? = Date()) -> Bool {
        return isSame(to: date, [.year])
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

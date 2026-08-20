//
//  DateFormatterConfig.swift
//  DTBKit
//
//  Created by moonShadow on 2025/8/12
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import Foundation

extension DTB {

    /// 对应 ``DateFormatter``，通过 self.hash 自动缓存，避免业务重复创建相同的 DateFormatter
    ///
    /// 所有字段均为 Optional：
    /// - `nil` → 不设置，formatter 使用系统默认值
    /// - 非 nil → 构建 formatter 时显式写入
    ///
    /// 与 ``NumberFormatterConfig`` 不同，DateFormatter 无 `[String: Any]?` / `NSNumber?`
    /// 类型的属性，所有字段均可直接 Hashable，无需桥接或排除。
    public struct DateFormatterConfig: Hashable {

        // MARK: - Style & Format

        public var dateFormat: String?
        public var dateStyle: DateFormatter.Style?
        public var timeStyle: DateFormatter.Style?

        // MARK: - Locale & Calendar

        public var locale: Locale?
        public var timeZone: TimeZone?
        public var calendar: Calendar?
        public var formattingContext: Formatter.Context?

        // MARK: - Behavior

        public var generatesCalendarDates: Bool?
        public var formatterBehavior: DateFormatter.Behavior?
        public var isLenient: Bool?
        public var doesRelativeDateFormatting: Bool?

        // MARK: - Date

        public var twoDigitStartDate: Date?
        public var defaultDate: Date?
        public var gregorianStartDate: Date?

        // MARK: - Symbols (AM/PM)

        public var amSymbol: String?
        public var pmSymbol: String?

        // MARK: - Symbols (数组)

        public var eraSymbols: [String]?
        public var monthSymbols: [String]?
        public var shortMonthSymbols: [String]?
        public var weekdaySymbols: [String]?
        public var shortWeekdaySymbols: [String]?
        public var longEraSymbols: [String]?
        public var veryShortMonthSymbols: [String]?
        public var standaloneMonthSymbols: [String]?
        public var shortStandaloneMonthSymbols: [String]?
        public var veryShortStandaloneMonthSymbols: [String]?
        public var veryShortWeekdaySymbols: [String]?
        public var standaloneWeekdaySymbols: [String]?
        public var shortStandaloneWeekdaySymbols: [String]?
        public var veryShortStandaloneWeekdaySymbols: [String]?
        public var quarterSymbols: [String]?
        public var shortQuarterSymbols: [String]?
        public var standaloneQuarterSymbols: [String]?
        public var shortStandaloneQuarterSymbols: [String]?

        // MARK: - Init

        public init(
            dateFormat: String? = nil,
            dateStyle: DateFormatter.Style? = nil,
            timeStyle: DateFormatter.Style? = nil,
            locale: Locale? = nil,
            timeZone: TimeZone? = nil,
            calendar: Calendar? = nil,
            formattingContext: Formatter.Context? = nil,
            generatesCalendarDates: Bool? = nil,
            formatterBehavior: DateFormatter.Behavior? = nil,
            isLenient: Bool? = nil,
            doesRelativeDateFormatting: Bool? = nil,
            twoDigitStartDate: Date? = nil,
            defaultDate: Date? = nil,
            gregorianStartDate: Date? = nil,
            amSymbol: String? = nil,
            pmSymbol: String? = nil,
            eraSymbols: [String]? = nil,
            monthSymbols: [String]? = nil,
            shortMonthSymbols: [String]? = nil,
            weekdaySymbols: [String]? = nil,
            shortWeekdaySymbols: [String]? = nil,
            longEraSymbols: [String]? = nil,
            veryShortMonthSymbols: [String]? = nil,
            standaloneMonthSymbols: [String]? = nil,
            shortStandaloneMonthSymbols: [String]? = nil,
            veryShortStandaloneMonthSymbols: [String]? = nil,
            veryShortWeekdaySymbols: [String]? = nil,
            standaloneWeekdaySymbols: [String]? = nil,
            shortStandaloneWeekdaySymbols: [String]? = nil,
            veryShortStandaloneWeekdaySymbols: [String]? = nil,
            quarterSymbols: [String]? = nil,
            shortQuarterSymbols: [String]? = nil,
            standaloneQuarterSymbols: [String]? = nil,
            shortStandaloneQuarterSymbols: [String]? = nil
        ) {
            self.dateFormat = dateFormat
            self.dateStyle = dateStyle
            self.timeStyle = timeStyle
            self.locale = locale ?? DTB.config.locale
            self.timeZone = timeZone ?? DTB.config.timeZone
            self.calendar = calendar ?? DTB.config.calendar
            self.formattingContext = formattingContext
            self.generatesCalendarDates = generatesCalendarDates
            self.formatterBehavior = formatterBehavior
            self.isLenient = isLenient
            self.doesRelativeDateFormatting = doesRelativeDateFormatting
            self.twoDigitStartDate = twoDigitStartDate
            self.defaultDate = defaultDate
            self.gregorianStartDate = gregorianStartDate
            self.amSymbol = amSymbol
            self.pmSymbol = pmSymbol
            self.eraSymbols = eraSymbols
            self.monthSymbols = monthSymbols
            self.shortMonthSymbols = shortMonthSymbols
            self.weekdaySymbols = weekdaySymbols
            self.shortWeekdaySymbols = shortWeekdaySymbols
            self.longEraSymbols = longEraSymbols
            self.veryShortMonthSymbols = veryShortMonthSymbols
            self.standaloneMonthSymbols = standaloneMonthSymbols
            self.shortStandaloneMonthSymbols = shortStandaloneMonthSymbols
            self.veryShortStandaloneMonthSymbols = veryShortStandaloneMonthSymbols
            self.veryShortWeekdaySymbols = veryShortWeekdaySymbols
            self.standaloneWeekdaySymbols = standaloneWeekdaySymbols
            self.shortStandaloneWeekdaySymbols = shortStandaloneWeekdaySymbols
            self.veryShortStandaloneWeekdaySymbols = veryShortStandaloneWeekdaySymbols
            self.quarterSymbols = quarterSymbols
            self.shortQuarterSymbols = shortQuarterSymbols
            self.standaloneQuarterSymbols = standaloneQuarterSymbols
            self.shortStandaloneQuarterSymbols = shortStandaloneQuarterSymbols
        }

        // MARK: - 构建 formatter

        /// 获取对应配置的 DateFormatter 实例（带缓存）。
        ///
        /// 以 `self` 为 key 查 `DTB.app` 中的缓存字典；
        /// 命中则直接返回，未命中则创建并缓存。
        ///
        /// 线程安全：`DTB.app` 有锁
        public func make() -> DateFormatter {
            let cacheKey = DTB.ConstKey<[DateFormatterConfig: DateFormatter]>("dtb.formatter.date.cache", useLock: true)
            var cache = DTB.app.get(cacheKey) ?? [:]
            if let cached = cache[self] {
                return cached
            }
            let f = DateFormatter()
            apply(to: f)
            cache[self] = f
            DTB.app.set(cache, key: cacheKey)
            return f
        }

        /// 将当前配置写入目标 formatter。
        ///
        /// - 原生 Optional 的属性：直接透传，`nil` 也会写入（即清空目标值）。
        /// - 原生非 Optional 的属性：仅非 nil 时写入。
        public func apply(to f: DateFormatter) {

            // MARK: 原生 Optional — 直接透传，nil 视为「清空」

            // Format
            f.dateFormat = dateFormat

            // Locale & Calendar
            f.locale = locale
            f.timeZone = timeZone
            f.calendar = calendar

            // Date
            f.twoDigitStartDate = twoDigitStartDate
            f.defaultDate = defaultDate
            f.gregorianStartDate = gregorianStartDate

            // Symbols (AM/PM)
            f.amSymbol = amSymbol
            f.pmSymbol = pmSymbol

            // Symbols (数组)
            f.eraSymbols = eraSymbols
            f.monthSymbols = monthSymbols
            f.shortMonthSymbols = shortMonthSymbols
            f.weekdaySymbols = weekdaySymbols
            f.shortWeekdaySymbols = shortWeekdaySymbols
            f.longEraSymbols = longEraSymbols
            f.veryShortMonthSymbols = veryShortMonthSymbols
            f.standaloneMonthSymbols = standaloneMonthSymbols
            f.shortStandaloneMonthSymbols = shortStandaloneMonthSymbols
            f.veryShortStandaloneMonthSymbols = veryShortStandaloneMonthSymbols
            f.veryShortWeekdaySymbols = veryShortWeekdaySymbols
            f.standaloneWeekdaySymbols = standaloneWeekdaySymbols
            f.shortStandaloneWeekdaySymbols = shortStandaloneWeekdaySymbols
            f.veryShortStandaloneWeekdaySymbols = veryShortStandaloneWeekdaySymbols
            f.quarterSymbols = quarterSymbols
            f.shortQuarterSymbols = shortQuarterSymbols
            f.standaloneQuarterSymbols = standaloneQuarterSymbols
            f.shortStandaloneQuarterSymbols = shortStandaloneQuarterSymbols

            // MARK: 原生非 Optional — 仅非 nil 时写入

            if let v = dateStyle { f.dateStyle = v }
            if let v = timeStyle { f.timeStyle = v }
            if let v = formattingContext { f.formattingContext = v }
            if let v = generatesCalendarDates { f.generatesCalendarDates = v }
            if let v = formatterBehavior { f.formatterBehavior = v }
            if let v = isLenient { f.isLenient = v }
            if let v = doesRelativeDateFormatting { f.doesRelativeDateFormatting = v }
        }
    }
}

// MARK: - Static 预置

extension DTB.DateFormatterConfig {

    /// 指定 dateFormat 的配置。
    ///
    /// - Parameters:
    ///   - format: 日期格式字符串，默认 "yyyy-MM-dd HH:mm"；空字符串回退到默认值
    public static func date(_ format: String = "yyyy-MM-dd HH:mm") -> Self {
        var c = Self()
        c.dateFormat = format.isEmpty ? "yyyy-MM-dd HH:mm" : format
        return c
    }
}

// MARK: - 实例转换

extension DTB.DateFormatterConfig {

    /// Date → 字符串（null-safe，内部走缓存 formatter）。
    public func string(from date: Date?) -> String? {
        guard let d = date else { return nil }
        return make().string(from: d)
    }

    /// 字符串 → Date（null-safe，内部走缓存 formatter）。
    public func date(from string: String?) -> Date? {
        guard let s = string else { return nil }
        return make().date(from: s)
    }
}

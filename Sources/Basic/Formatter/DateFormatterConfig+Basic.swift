//
//  DateFormatterConfig+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/18
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension Wrapper where Base == Date {

    /// Convert to string with dateFormatter.
    ///
    /// 格式化字符串；返回 wrapper，便于链式。
    @inline(__always)
    public func string(formatter: DTB.DateFormatterConfig) -> Wrapper<String> {
        return toString(formatter).dtb
    }

    /// Convert to string with dateFormatter.
    ///
    /// 格式化字符串。直接返回字符串，便于使用。
    ///
    /// e.g.
    /// ```
    ///     let a = Date().dtb.toString(.dtb.date("yyyy-MM-dd HH:mm"))
    /// ```
    @inline(__always)
    public func toString(_ formatter: DTB.DateFormatterConfig) -> String {
        return formatter.make().string(from: me)
    }
}

extension Wrapper where Base == String {

    /// Convert to ``Date`` with dateFormatter.
    ///
    /// 字符串 → 日期；返回 wrapper，便于链式。
    @inline(__always)
    public func date(formatter: DTB.DateFormatterConfig) -> Wrapper<Date>? {
        return toDate(formatter)?.dtb
    }

    /// Convert to ``Date`` with dateFormatter.
    ///
    /// 字符串 → 日期。直接返回日期，便于使用。
    @inline(__always)
    public func toDate(_ formatter: DTB.DateFormatterConfig) -> Date? {
        return formatter.date(from: me)
    }
}

//
//  DateFormat+Basic.swift
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
    
    /// DateFormatter
    @inline(__always)
    public func string(formatter: DateFormatter) -> Wrapper<String> {
        return formatter.string(from: me).dtb
    }
    
    /// Format string
    @inline(__always)
    public func toString(_ str: String = "yyyy-MM-dd HH:mm") -> String {
        let old = DTB.config.dateFormatter.dateFormat
        DTB.config.dateFormatter.dateFormat = str.isEmpty ? "yyyy-MM-dd HH:mm" : str
        let result = DTB.config.dateFormatter.string(from: me)
        DTB.config.dateFormatter.dateFormat = old
        return result
    }
}

extension Wrapper where Base == String {
    
    /// Convert to ``Date``.
    public func date(formatter: DateFormatter) -> Wrapper<Date>? {
        return formatter.date(from: me)?.dtb
    }
    
    /// Format to ``Date``.
    public func toDate(_ str: String = "yyyy-MM-dd HH:mm") -> Date? {
        let old = DTB.config.dateFormatter.dateFormat
        DTB.config.dateFormatter.dateFormat = str.isEmpty ? "yyyy-MM-dd HH:mm" : str
        let result = DTB.config.dateFormatter.date(from: me)
        DTB.config.dateFormatter.dateFormat = old
        return result
    }
}

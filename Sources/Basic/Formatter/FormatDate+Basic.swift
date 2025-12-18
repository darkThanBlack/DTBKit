//
//  DateFormatterUsage+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/18
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base == String {
    
    /// Convert to ``Date``.
    public func toDate(_ formatter: DateFormatter) -> Wrapper<Date>? {
        return formatter.date(from: me)?.dtb
    }
    
    /// Format to ``Date``.
    public func formatDate(_ str: String = "yyyy-MM-dd HH:mm") -> Wrapper<Date>? {
        return DTB.config.dateFormatter.dtb.dateFormat(str).value.date(from: me)?.dtb
    }
}

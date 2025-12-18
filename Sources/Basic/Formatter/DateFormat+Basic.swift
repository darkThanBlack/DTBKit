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
    public func toString(_ formatter: DateFormatter = DTB.config.dateFormatter) -> Wrapper<String> {
        return formatter.string(from: me).dtb
    }
    
    /// Format string
    @inline(__always)
    public func format(_ str: String = "yyyy-MM-dd HH:mm") -> String {
        return DTB.config.dateFormatter.dtb.dateFormat(str).value.string(from: me)
    }
    
}

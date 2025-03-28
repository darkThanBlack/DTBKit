//
//  Date+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2024/10/17
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Date: Structable {}

extension StaticWrapper where T == Date {
    
    /// From 's' timeStamp (length == 10) | 从 10 位秒级时间戳生成
    @inline(__always)
    public func create(s: Int64?) -> T? {
        guard let t = s, String(t).count == 10 else {
            return nil
        }
        return Date(timeIntervalSince1970: TimeInterval(t))
    }
    
    /// From 'ms' timeStamp (length == 13) | 从 13 位毫秒级时间戳生成
    @inline(__always)
    public func create(ms: Int64?) -> T? {
        guard let t = ms, String(t).count == 13 else {
            return nil
        }
        return Date(timeIntervalSince1970: TimeInterval(t / 1000))
    }
}

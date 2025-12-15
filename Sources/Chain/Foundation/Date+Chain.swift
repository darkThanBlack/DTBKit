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
    
    /// From 's' timeStamp (length == 9 || 10) | 从秒级时间戳生成
    @inline(__always)
    public func create(s: Int64?) -> T? {
        guard let t = s, t > 0 else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(t))
    }
    
    /// From 's' timeStamp | 从秒级时间戳生成
    @inline(__always)
    public func create(s: Double?) -> T? {
        guard let t = s, t > 0 else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(t))
    }
    
    /// From 's' timeStamp | 从秒级时间戳生成
    @inline(__always)
    public func create(s: String?) -> T? {
        return create(s: Double(s ?? ""))
    }
    
    /// From 'ms' timeStamp (length == 12 || 13) | 从毫秒级时间戳生成
    @inline(__always)
    public func create(ms: Int64?) -> T? {
        guard let t = ms, t > 0 else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(t / 1000))
    }
    
    /// From 'ms' timeStamp | 从毫秒级时间戳生成
    @inline(__always)
    public func create(ms: Double?) -> T? {
        guard let t = ms else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(t / 1000.0))
    }
    
    /// From 'ms' timeStamp | 从毫秒级时间戳生成
    @inline(__always)
    public func create(ms: String?) -> T? {
        return create(ms: Double(ms ?? ""))
    }
}

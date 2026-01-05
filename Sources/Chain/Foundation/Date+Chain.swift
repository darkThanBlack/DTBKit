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

extension StaticWrapper where T == Date {
    
    /// From 's' timeStamp (length == 9 || 10) | 从秒级时间戳生成
    @inline(__always)
    public func create(s: any FixedWidthInteger) -> T {
        return Date(timeIntervalSince1970: TimeInterval(s))
    }
    
    /// From 's' timeStamp | 从秒级时间戳生成
    @inline(__always)
    public func create(s: any BinaryFloatingPoint) -> T {
        return Date(timeIntervalSince1970: TimeInterval(s))
    }
    
    /// From 's' timeStamp | 从秒级时间戳生成
    @inline(__always)
    public func create(s: String?) -> T? {
        guard let s = s, s.isEmpty == false, let t = Double(s) else {
            return nil
        }
        return Date(timeIntervalSince1970: t)
    }
    
    /// From 'ms' timeStamp (length == 12 || 13) | 从毫秒级时间戳生成
    @inline(__always)
    public func create(ms: any FixedWidthInteger) -> T {
        return Date(timeIntervalSince1970: TimeInterval(ms) / 1000.0)
    }
    
    /// From 'ms' timeStamp | 从毫秒级时间戳生成
    @inline(__always)
    public func create(ms: any BinaryFloatingPoint) -> T {
        return Date(timeIntervalSince1970: TimeInterval(ms) / 1000.0)
    }
    
    /// From 'ms' timeStamp | 从毫秒级时间戳生成
    @inline(__always)
    public func create(ms: String?) -> T? {
        guard let ms = ms, ms.isEmpty == false, let t = Double(ms) else {
            return nil
        }
        return Date(timeIntervalSince1970: t / 1000.0)
    }
}

//
//  DateConvert+Basic.swift
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
    
    /// Get Int64 by .timeIntervalSince1970
    @inline(__always)
    public func s() -> Wrapper<Int64> {
        return Int64(me.timeIntervalSince1970).dtb
    }
    
    /// Get Int64 by timeIntervalSince1970 * 1000 (length == 13) | 获取 13 位毫秒时间戳
    @inline(__always)
    public func ms() -> Wrapper<Int64> {
        return Int64(me.timeIntervalSince1970 * 1000).dtb
    }
    
}

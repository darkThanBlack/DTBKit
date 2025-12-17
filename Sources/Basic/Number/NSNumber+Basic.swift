//
//  NSNumber+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/15
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension StaticWrapper where T == NSNumber {
    
    /// Return NSNumber(value: Double.nan) when fail.
    public func create(_ value: Any) -> NSNumber {
        if let d = value as? (any BinaryFloatingPoint) {
            return NSNumber(value: Double(d))
        }
        if let i = value as? (any FixedWidthInteger) {
            return NSNumber(value: Int64(i))
        }
        if let v = value as? NSNumber {
            return v
        }
        return NSNumber(value: Double.nan)
    }
}

extension Wrapper where Base == NSNumber {
    
    @inline(__always)
    public func int() -> Wrapper<Int> {
        return me.intValue.dtb
    }
    
    @inline(__always)
    public func int64() -> Wrapper<Int64> {
        return me.int64Value.dtb
    }
    
    @inline(__always)
    public func double() -> Wrapper<Double> {
        return me.doubleValue.dtb
    }
}

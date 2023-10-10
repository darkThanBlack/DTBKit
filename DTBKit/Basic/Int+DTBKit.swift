//
//  Int+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/29
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import Foundation

/// Type convert
extension DTBKitWrapper where Base: FixedWidthInteger {
    
    ///
    public var number: DTBKitWrapper<NSNumber> {
        if let value = me as? Int {
            return NSNumber(value: value).dtb
        }
        if let value = me as? Int64 {
            return NSNumber(value: value).dtb
        }
        if let value = me as? UInt64 {
            return NSNumber(value: value).dtb
        }
        if let value = me as? Int8 {
            return NSNumber(value: value).dtb
        }
        if let value = me as? UInt8 {
            return NSNumber(value: value).dtb
        }
        if let value = me as? Int16 {
            return NSNumber(value: value).dtb
        }
        if let value = me as? UInt16 {
            return NSNumber(value: value).dtb
        }
        if let value = me as? Int32 {
            return NSNumber(value: value).dtb
        }
        if let value = me as? UInt32 {
            return NSNumber(value: value).dtb
        }
        fatalError()
    }
    
    ///
    public var float: DTBKitWrapper<Float> {
        return Float(me).dtb
    }
    
    ///
    public var double: DTBKitWrapper<Double> {
        return Double(me).dtb
    }
    
    ///
    public var string: DTBKitWrapper<String> {
        return "\(me)".dtb
    }
    
    ///
    public func div100() -> Double {
        return Double(me)
    }
    
    ///
    public func div100() -> String {
        return "\(Double(me) / 100.0)"
    }
    
}

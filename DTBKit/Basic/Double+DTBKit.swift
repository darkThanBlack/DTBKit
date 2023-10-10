//
//  CGFloat+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/29
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import Foundation

extension DTBKitWrapper where Base: BinaryFloatingPoint {
    
    ///
    public func positiveOrZero() -> Self? {
        
        return self
    }
    
    ///
    public var `float`: DTBKitWrapper<Float>? {
        if let value = me as? Float {
            return Float(exactly: value)?.dtb
        }
        if let value = me as? Double {
            return Float(exactly: value)?.dtb
        }
        return nil
    }
    
    ///
    public var `double`: DTBKitWrapper<Double>? {
        if let value = me as? Double {
            return Double(value).dtb
        }
        if let value = me as? Float {
            return Double(value).dtb
        }
        return nil
    }
}


//    /// for uni test
//    public static func test_div() {
//
//    }
    
//    public static func / (lhs: Base, rhs: DTBKitWrapper<Base>) -> Base {
//        print("override 01")
//        return lhs / rhs.me
//    }
//
//    public static func / (lhs: DTBKitWrapper<Base>, rhs: DTBKitWrapper<Base>) -> Base {
//        print("override 02")
//        return lhs.me / rhs.me
//    }
    

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

/// Convert
extension DTBKitWrapper where Base: FixedWidthInteger {
    
//    public var number: DTBKitWrapper<NSNumber> {
//        return NSNumber(value: me).dtb
//    }
}

extension DTBKitWrapper where Base == Int64 {
    
    func square() -> Int64 {
        
        return me * me
    }
}

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

extension Int: DTBKitableValue {}

extension Int64: DTBKitableValue {}

extension DTBKitWrapper where Base: FixedWidthInteger {
    
}

extension DTBKitWrapper where Base == Int64 {
    
    func square() -> Int64 {
        return me * me
    }
}

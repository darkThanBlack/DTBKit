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

extension DTBKitWrapper where Base == Double {
    
    public static func test_div() {
        
        
    }
    
    public static func / (lhs: Base, rhs: DTBKitWrapper<Base>) -> Base {
        print("override 01")
        return lhs / rhs.me
    }
    
    public static func / (lhs: DTBKitWrapper<Base>, rhs: DTBKitWrapper<Base>) -> Base {
        print("override 02")
        return lhs.me / rhs.me
    }
    
}

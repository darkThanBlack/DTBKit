//
//  NSRange+Chain.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/11/6
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
extension DTBKitMutableWrapper where Base == NSRange {
    
    ///
    @discardableResult
    public func location(_ value: Int) -> Self where Base: DTBKitChainable {
        me.location = value
        return self
    }
    
    ///
    @discardableResult
    public func length(_ value: Int) -> Self where Base: DTBKitChainable {
        me.length = max(0, value)
        return self
    }
}

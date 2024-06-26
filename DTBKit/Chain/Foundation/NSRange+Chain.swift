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

extension DTBKitStaticWrapper where T == NSRange {
    
    public func create(_ location: Int, _ length: Int) -> T {
        return NSRange(location: location, length: length)
    }
}

extension DTBKitMutableWrapper where Base == NSRange {
    
    @discardableResult
    public func location(_ value: Int) -> Self where Base: DTBKitChainable {
        me.location = value
        return self
    }
    
    @discardableResult
    public func length(_ value: Int) -> Self where Base: DTBKitChainable {
        me.length = value
        return self
    }
}

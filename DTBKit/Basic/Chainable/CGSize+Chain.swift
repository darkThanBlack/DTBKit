//
//  CGSize+Chain.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/10/7
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
extension DTBKitMutableWrapper where Base == CGSize {
    
    @discardableResult
    public func width(_ value: CGFloat) -> Self where Base: DTBKitChainable {
        me.width = value
        return self
    }
    
    @discardableResult
    public func height(_ value: CGFloat) -> Self where Base: DTBKitChainable {
        me.height = value
        return self
    }
}

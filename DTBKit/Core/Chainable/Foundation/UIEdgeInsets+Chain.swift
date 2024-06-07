//
//  UIEdgeInsets+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/29
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTBKitMutableWrapper where Base == UIEdgeInsets {
    
    @discardableResult
    public func top(_ value: CGFloat) -> Self where Base: DTBKitChainable {
        me.top = value
        return self
    }
    
    @discardableResult
    public func left(_ value: CGFloat) -> Self where Base: DTBKitChainable {
        me.left = value
        return self
    }
    
    @discardableResult
    public func bottom(_ value: CGFloat) -> Self where Base: DTBKitChainable {
        me.bottom = value
        return self
    }
    
    @discardableResult
    public func right(_ value: CGFloat) -> Self where Base: DTBKitChainable {
        me.right = value
        return self
    }
}

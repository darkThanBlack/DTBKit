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

extension DTBKitStaticWrapper where T == CGSize {
    
    public func create(_ width: CGFloat, _ height: CGFloat) -> T {
        return CGSize(width: width, height: height)
    }
}

extension DTBKitMutableWrapper where Base == CGSize, Base: DTBKitStructChainable {
    
    @discardableResult
    public func width(_ value: CGFloat) -> Self {
        me.width = value
        return self
    }
    
    @discardableResult
    public func height(_ value: CGFloat) -> Self {
        me.height = value
        return self
    }
}

extension DTBKitStaticWrapper where T == CGRect {
    
}

extension DTBKitMutableWrapper where Base == CGRect, Base: DTBKitStructChainable {

    @discardableResult
    public func origin(_ value: CGPoint) -> Self {
        me.origin = value
        return self
    }
    
    @discardableResult
    public func size(_ value: CGSize) -> Self {
        me.size = value
        return self
    }
    
    @discardableResult
    public func x(_ value: Double) -> Self {
        me.origin.x = value
        return self
    }
    
    @discardableResult
    public func y(_ value: Double) -> Self {
        me.origin.y = value
        return self
    }
    
    @discardableResult
    public func width(_ value: CGFloat) -> Self {
        me.size.width = value
        return self
    }
    
    @discardableResult
    public func height(_ value: CGFloat) -> Self {
        me.size.height = value
        return self
    }
}

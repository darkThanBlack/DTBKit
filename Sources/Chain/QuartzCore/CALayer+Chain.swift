//
//  CALayer+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2024/7/22
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base: CALayer & Chainable {
    
    @inline(__always)
    @discardableResult
    public func masksToBounds(_ value: Bool) -> Self {
        me.masksToBounds = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func cornerRadius(_ value: CGFloat) -> Self {
        me.cornerRadius = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func borderWidth(_ value: CGFloat) -> Self {
        me.borderWidth = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func borderColor(_ value: CGColor) -> Self {
        me.borderColor = value
        return self
    }
    
    // etc.
}

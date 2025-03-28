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
    
    @discardableResult
    public func masksToBounds(_ value: Bool) -> Self {
        me.masksToBounds = value
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ value: CGFloat) -> Self {
        me.cornerRadius = value
        return self
    }
    
    @discardableResult
    public func borderWidth(_ value: CGFloat) -> Self {
        me.borderWidth = value
        return self
    }
    
    @discardableResult
    public func borderColor(_ value: CGColor) -> Self {
        me.borderColor = value
        return self
    }
    
    // etc.
}

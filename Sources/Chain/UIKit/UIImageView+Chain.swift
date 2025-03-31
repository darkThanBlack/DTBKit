//
//  UIImageView+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/3
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base: UIImageView & Chainable {
    
    @inline(__always)
    @discardableResult
    public func image(_ value: UIImage?) -> Self {
        me.image = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func highlightedImage(_ value: UIImage?) -> Self {
        me.highlightedImage = value
        return self
    }
    
    @inline(__always)
    @discardableResult
    public func isHighlighted(_ value: Bool) -> Self {
        me.isHighlighted = value
        return self
    }
}

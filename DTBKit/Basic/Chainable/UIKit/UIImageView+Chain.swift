//
//  UIImageView+Chain.swift
//  XMKit
//
//  Created by moonShadow on 2024/1/3
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension XMKitWrapper where Base: UIImageView & XMKitChainable {
    
    @discardableResult
    public func image(_ value: UIImage?) -> Self {
        me.image = value
        return self
    }
    
    @discardableResult
    public func highlightedImage(_ value: UIImage?) -> Self {
        me.highlightedImage = value
        return self
    }
    
    @discardableResult
    public func isHighlighted(_ value: Bool) -> Self {
        me.isHighlighted = value
        return self
    }
}

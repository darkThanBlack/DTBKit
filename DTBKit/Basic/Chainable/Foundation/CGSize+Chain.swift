//
//  CGSize+Chain.swift
//  XMKit_Example
//
//  Created by moonShadow on 2023/10/7
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// Size width and height will always >= 0.0 semantically.
extension XMKitMutableWrapper where Base == CGSize {
    
    /// Always >= 0.0.
    @discardableResult
    public func width(_ value: CGFloat) -> Self where Base: XMKitChainable {
        me.width = max(0, value)
        return self
    }
    
    /// Always >= 0.0.
    @discardableResult
    public func height(_ value: CGFloat) -> Self where Base: XMKitChainable {
        me.height = max(0, value)
        return self
    }
}

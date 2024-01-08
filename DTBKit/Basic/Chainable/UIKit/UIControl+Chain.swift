//
//  UIControl+Chain.swift
//  XMKit
//
//  Created by moonShadow on 2024/1/4
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension XMKitWrapper where Base: UIControl {
    
    @discardableResult
    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> Self {
        me.addTarget(target, action: action, for: controlEvents)
        return self
    }
    
    // etc...
}

//
//  UITextView+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2024/2/6
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base: UITextView {
    
    @inline(__always)
    @discardableResult
    public func text(_ value: String?) -> Self {
        me.text = value
        return self
    }
    
    // etc...
}

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

extension DTBKitWrapper where Base: UITextView {
    
    @discardableResult
    public func text(_ value: String?) -> Self {
        me.text = value
        return self
    }
    
    // etc...
}

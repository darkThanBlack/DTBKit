//
//  UILabel+Basic.swift
//  DTBKit
//
//  Created by moonShadow on 2025/10/11
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base: UILabel {
    
    ///
    @discardableResult
    public func hiddenWhenEmpty() -> Self {
        me.isHidden = {
            if let str = me.text, str.isEmpty == false {
                return false
            }
            if let attr = me.attributedText, attr.string.isEmpty == false {
                return false
            }
            return true
        }()
        return self
    }
}

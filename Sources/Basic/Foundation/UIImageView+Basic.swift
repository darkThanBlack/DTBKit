//
//  UIImageView+UI.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/26
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base: UIImageView {
    
    @discardableResult
    public func hiddenWithEmptyImage() -> Self {
        me.isHidden = {
            if me.image != nil { return false }
            if me.highlightedImage != nil { return false }
            if me.animationImages != nil { return false }
            return true
        }()
        return self
    }
    
}

//
//  UIButton+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/4
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTBKitWrapper where Base: UIButton {
    
    @discardableResult
    public func setTitle(_ title: String?, for state: UIControl.State) -> Self {
        me.setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    public func setTitleColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        me.setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    public func setImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        me.setImage(image, for: state)
        return self
    }
    
    @discardableResult
    public func contentEdgeInsets(_ value: UIEdgeInsets) -> Self {
        me.contentEdgeInsets = value
        return self
    }
    
    // etc...
}

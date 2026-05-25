//
//  UILabel+Theme.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/25
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base: UILabel {
    
    ///
    @discardableResult
    public func textStyle(_ value: Any?) -> Self {
        
        func setup(_ style: DTB.TextStyle) {
            me.numberOfLines = 0
            me.font = .dtb.create(style.fontSize, weight: style.fontWeight)
            me.textColor = style.textColor
        }
        if let style = DTB.Providers.get(DTB.Providers.textStyleKey)?.create(value) {
            setup(style)
        }
        if let style = value as? DTB.TextStyle {
            setup(style)
        }
        return self
    }
}

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
        if let style: DTB.TextStyle = {
            if let p = DTB.Providers.get(DTB.Providers.textStyleKey), let s = p.create(value) {
                return s
            }
            // FIXME: init from dict
            if let s = value as? DTB.TextStyle {
                return s
            }
            return nil
        }() {
            self.numberOfLines(0)
                .font(style.font)
                .textColor(style.textColor)
        }
        return self
    }
}

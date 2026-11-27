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

extension DTB.Wrapper where Base: UILabel {
    
    ///
    @discardableResult
    public func textStyle(_ value: Any?) -> Self {
        guard let style = DTB.TextStyle.style(value) else {
            return self
        }
        return self.numberOfLines(0)
            .font(style.font)
            .textColor(style.textColor)
    }
}

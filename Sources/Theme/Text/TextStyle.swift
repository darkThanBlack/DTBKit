//
//  TextStyle.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/25
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    public struct TextStyle {
        
        /// Convert to attr
        public var attr: [NSAttributedString.Key : Any] {
            return [
                .font: UIFont.dtb.create(font),
                .foregroundColor: textColor
            ]
        }
        
        public var font: UIFont?
        
        public var textColor: UIColor?
        
        public init(font: UIFont? = nil, textColor: UIColor? = nil) {
            self.font = font
            self.textColor = textColor
        }
    }
}

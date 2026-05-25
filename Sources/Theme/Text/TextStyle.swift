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
                .font: UIFont.dtb.create(fontSize, weight: fontWeight),
                .foregroundColor: textColor
            ]
        }
        
        public var fontSize: CGFloat
        
        public var fontWeight: UIFont.Weight
        
        public var textColor: UIColor
        
        public init(fontSize: CGFloat, fontWeight: UIFont.Weight, textColor: UIColor) {
            self.fontSize = fontSize
            self.fontWeight = fontWeight
            self.textColor = textColor
        }
    }
}

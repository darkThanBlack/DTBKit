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
        
        /// Simple replacement for .dtb.create
        public static func style(_ param: Any?) -> DTB.TextStyle? {
            if let p = DTB.app.get(DTB.Providers.stylesKey), let style = p.createTextStyle(param) {
                return style
            }
            if let dict = param as? [String: Any], let style = DTB.TextStyle(dict: dict) {
                return style
            }
            return nil
        }
        
        /// 从字典创建形状样式
        public init?(dict: [String: Any]?) {
            guard let dict = dict else { return nil }
            
            self.font = .dtb.create(dict["font"])
            self.textColor = .dtb.create(dict["textColor"])
        }
    }
}

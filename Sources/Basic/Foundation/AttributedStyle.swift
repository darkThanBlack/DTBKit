//
//  AttributedStyle.swift
//  DTBKit
//
//  Created by moonShadow on 2026/11/26
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {
    
    ///
    public struct AttributedStyle {
        
        // MARK: - Font & Paragraph
        
        public var font: UIFont?
        
        public var paragraphStyle: NSParagraphStyle?
        
        // MARK: - Color
        
        public var foregroundColor: UIColor?
        
        public var backgroundColor: UIColor?
        
        public var strokeColor: UIColor?
        
        public var underlineColor: UIColor?
        
        public var strikethroughColor: UIColor?
        
        // MARK: - Spacing & Offset
        
        public var kern: CGFloat?
        
        /// iOS 14+
        public var tracking: CGFloat?
        
        public var baselineOffset: CGFloat?
        
        public var obliqueness: CGFloat?
        
        public var strokeWidth: CGFloat?
        
        // MARK: - Style
        
        public var ligature: Int?
        
        public var underlineStyle: Int?
        
        public var strikethroughStyle: Int?
        
        /// `NSWritingDirection.rawValue | NSWritingDirectionFormatType.rawValue`
        public var expansion: Int?
        
        // MARK: - Content
        
        public var shadow: NSShadow?
        
        public var textEffect: String?
        
        public var attachment: NSTextAttachment?
        
        /// URL 或 String
        public var link: Any?
        
        // MARK: - Init
        
        public init(
            font: UIFont? = nil,
            paragraphStyle: NSParagraphStyle? = nil,
            foregroundColor: UIColor? = nil,
            backgroundColor: UIColor? = nil,
            strokeColor: UIColor? = nil,
            underlineColor: UIColor? = nil,
            strikethroughColor: UIColor? = nil,
            kern: CGFloat? = nil,
            tracking: CGFloat? = nil,
            baselineOffset: CGFloat? = nil,
            obliqueness: CGFloat? = nil,
            strokeWidth: CGFloat? = nil,
            ligature: Int? = nil,
            underlineStyle: Int? = nil,
            strikethroughStyle: Int? = nil,
            expansion: Int? = nil,
            shadow: NSShadow? = nil,
            textEffect: String? = nil,
            attachment: NSTextAttachment? = nil,
            link: Any? = nil
        ) {
            self.font = font
            self.paragraphStyle = paragraphStyle
            self.foregroundColor = foregroundColor
            self.backgroundColor = backgroundColor
            self.strokeColor = strokeColor
            self.underlineColor = underlineColor
            self.strikethroughColor = strikethroughColor
            self.kern = kern
            self.tracking = tracking
            self.baselineOffset = baselineOffset
            self.obliqueness = obliqueness
            self.strokeWidth = strokeWidth
            self.ligature = ligature
            self.underlineStyle = underlineStyle
            self.strikethroughStyle = strikethroughStyle
            self.expansion = expansion
            self.shadow = shadow
            self.textEffect = textEffect
            self.attachment = attachment
            self.link = link
        }
        
        public init(attr: [NSAttributedString.Key: Any]? = nil) {
            let attr = attr ?? [:]
            self.font = attr[.font] as? UIFont
            self.paragraphStyle = attr[.paragraphStyle] as? NSParagraphStyle
            self.foregroundColor = attr[.foregroundColor] as? UIColor
            self.backgroundColor = attr[.backgroundColor] as? UIColor
            self.strokeColor = attr[.strokeColor] as? UIColor
            self.underlineColor = attr[.underlineColor] as? UIColor
            self.strikethroughColor = attr[.strikethroughColor] as? UIColor
            self.kern = attr[.kern] as? CGFloat
            if #available(iOS 14.0, *) {
                self.tracking = attr[.tracking] as? CGFloat
            } else {
                self.tracking = nil
            }
            self.baselineOffset = attr[.baselineOffset] as? CGFloat
            self.obliqueness = attr[.obliqueness] as? CGFloat
            self.strokeWidth = attr[.strokeWidth] as? CGFloat
            self.ligature = attr[.ligature] as? Int
            self.underlineStyle = attr[.underlineStyle] as? Int
            self.strikethroughStyle = attr[.strikethroughStyle] as? Int
            self.expansion = attr[.expansion] as? Int
            self.shadow = attr[.shadow] as? NSShadow
            self.textEffect = attr[.textEffect] as? String
            self.attachment = attr[.attachment] as? NSTextAttachment
            self.link = attr[.link]
        }
        
        public var attr: [NSAttributedString.Key: Any] {
            var result: [NSAttributedString.Key: Any] = [:]
            result[.font] = font
            result[.paragraphStyle] = paragraphStyle
            result[.foregroundColor] = foregroundColor
            result[.backgroundColor] = backgroundColor
            result[.strokeColor] = strokeColor
            result[.underlineColor] = underlineColor
            result[.strikethroughColor] = strikethroughColor
            result[.kern] = kern
            result[.baselineOffset] = baselineOffset
            result[.obliqueness] = obliqueness
            result[.strokeWidth] = strokeWidth
            result[.ligature] = ligature
            result[.underlineStyle] = underlineStyle
            result[.strikethroughStyle] = strikethroughStyle
            result[.expansion] = expansion
            result[.shadow] = shadow
            result[.textEffect] = textEffect
            result[.attachment] = attachment
            result[.link] = link
            if #available(iOS 14.0, *) {
                result[.tracking] = tracking
            }
            return result
        }
    }
}

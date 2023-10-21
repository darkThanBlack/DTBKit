//
//  AttributedStringKey+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/10/21
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTBKitWrapper where Base == Dictionary<NSAttributedString.Key, Any> {
    
    @discardableResult
    public mutating func font(_ value: UIFont) -> Self {
//        me[.font] = value
        
        return self
    }

//    /************************ Attributes ************************/
//    @available(iOS 6.0, *)
//    public static let font: NSAttributedString.Key
//
//    @available(iOS 6.0, *)
//    public static let paragraphStyle: NSAttributedString.Key // NSParagraphStyle, default defaultParagraphStyle
//
//    @available(iOS 6.0, *)
//    public static let foregroundColor: NSAttributedString.Key // UIColor, default blackColor
//
//    @available(iOS 6.0, *)
//    public static let backgroundColor: NSAttributedString.Key // UIColor, default nil: no background
//
//    @available(iOS 6.0, *)
//    public static let ligature: NSAttributedString.Key // NSNumber containing integer, default 1: default ligatures, 0: no ligatures
//
//    @available(iOS 6.0, *)
//    public static let kern: NSAttributedString.Key // NSNumber containing floating point value, in points; amount to modify default kerning. 0 means kerning is disabled.
//
//    @available(iOS 14.0, *)
//    public static let tracking: NSAttributedString.Key // NSNumber containing floating point value, in points; amount to modify default tracking. 0 means tracking is disabled.
//
//    @available(iOS 6.0, *)
//    public static let strikethroughStyle: NSAttributedString.Key // NSNumber containing integer, default 0: no strikethrough
//
//    @available(iOS 6.0, *)
//    public static let underlineStyle: NSAttributedString.Key // NSNumber containing integer, default 0: no underline
//
//    @available(iOS 6.0, *)
//    public static let strokeColor: NSAttributedString.Key // UIColor, default nil: same as foreground color
//
//    @available(iOS 6.0, *)
//    public static let strokeWidth: NSAttributedString.Key // NSNumber containing floating point value, in percent of font point size, default 0: no stroke; positive for stroke alone, negative for stroke and fill (a typical value for outlined text would be 3.0)
//
//    @available(iOS 6.0, *)
//    public static let shadow: NSAttributedString.Key // NSShadow, default nil: no shadow
//
//    @available(iOS 7.0, *)
//    public static let textEffect: NSAttributedString.Key // NSString, default nil: no text effect
//
//
//    @available(iOS 7.0, *)
//    public static let attachment: NSAttributedString.Key // NSTextAttachment, default nil
//
//    @available(iOS 7.0, *)
//    public static let link: NSAttributedString.Key // NSURL (preferred) or NSString
//
//    @available(iOS 7.0, *)
//    public static let baselineOffset: NSAttributedString.Key // NSNumber containing floating point value, in points; offset from baseline, default 0
//
//    @available(iOS 7.0, *)
//    public static let underlineColor: NSAttributedString.Key // UIColor, default nil: same as foreground color
//
//    @available(iOS 7.0, *)
//    public static let strikethroughColor: NSAttributedString.Key // UIColor, default nil: same as foreground color
//
//    @available(iOS 7.0, *)
//    public static let obliqueness: NSAttributedString.Key // NSNumber containing floating point value; skew to be applied to glyphs, default 0: no skew
//
//    @available(iOS 7.0, *)
//    public static let expansion: NSAttributedString.Key // NSNumber containing floating point value; log of expansion factor to be applied to glyphs, default 0: no expansion
//
//
//    @available(iOS 7.0, *)
//    public static let writingDirection: NSAttributedString.Key // NSArray of NSNumbers representing the nested levels of writing direction overrides as defined by Unicode LRE, RLE, LRO, and RLO characters.  The control characters can be obtained by masking NSWritingDirection and NSWritingDirectionFormatType values.  LRE: NSWritingDirectionLeftToRight|NSWritingDirectionEmbedding, RLE: NSWritingDirectionRightToLeft|NSWritingDirectionEmbedding, LRO: NSWritingDirectionLeftToRight|NSWritingDirectionOverride, RLO: NSWritingDirectionRightToLeft|NSWritingDirectionOverride,
//
//
//    @available(iOS 6.0, *)
//    public static let verticalGlyphForm: NSAttributedString.Key // An NSNumber containing an integer value.  0 means horizontal text.  1 indicates vertical text.  If not specified, it could follow higher-level vertical orientation settings.  Currently on iOS, it's always horizontal.  The behavior for any other value is undefined.
//}

}

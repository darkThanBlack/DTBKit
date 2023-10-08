//
//  NumberFormatter+Chain.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/10/8
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTBKitWrapper where Base: NumberFormatter & DTBKitChainable {
    
    @discardableResult
    public func formattingContext(_ value: Formatter.Context) -> Self {
        me.formattingContext = value
        return self
    }
    
//    @discardableResult
//    public func string(from number: NSNumber) -> DTBKitWrapper<String>? {
//        return me.string(from: number)?.dtb
//    }
//
//    @discardableResult
//    public func number(from string: String) -> DTBKitWrapper<NSNumber>? {
//        return me.number(from: string)?.dtb
//    }
    
//    @available(iOS 4.0, *)
//    open class func localizedString(from num: NSNumber, number nstyle: NumberFormatter.Style) -> String
//
//    open class func defaultFormatterBehavior() -> NumberFormatter.Behavior
//
//    open class func setDefaultFormatterBehavior(_ behavior: NumberFormatter.Behavior)
    
    @discardableResult
    public func numberStyle(_ value: NumberFormatter.Style) -> Self {
        me.numberStyle = value
        return self
    }
    
    @discardableResult
    public func locale(_ value: Locale) -> Self {
        me.locale = value
        return self
    }
    
    @discardableResult
    public func generatesDecimalNumbers(_ value: Bool) -> Self {
        me.generatesDecimalNumbers = value
        return self
    }
    
    @discardableResult
    public func formatterBehavior(_ value: NumberFormatter.Behavior) -> Self {
        me.formatterBehavior = value
        return self
    }
    
    @discardableResult
    public func negativeFormat(_ value: String) -> Self {
        me.negativeFormat = value
        return self
    }
    
    @discardableResult
    public func textAttributesForNegativeValues(_ value: [String : Any]?) -> Self {
        me.textAttributesForNegativeValues = value
        return self
    }
    
    @discardableResult
    public func positiveFormat(_ value: String) -> Self {
        me.positiveFormat = value
        return self
    }

    @discardableResult
    public func textAttributesForPositiveValues(_ value: [String : Any]?) -> Self {
        me.textAttributesForPositiveValues = value
        return self
    }
    
    @discardableResult
    public func allowsFloats(_ value: Bool) -> Self {
        me.allowsFloats = value
        return self
    }
    
    @discardableResult
    public func decimalSeparator(_ value: String) -> Self {
        me.decimalSeparator = value
        return self
    }
    
    @discardableResult
    public func alwaysShowsDecimalSeparator(_ value: Bool) -> Self {
        me.alwaysShowsDecimalSeparator = value
        return self
    }
    
    @discardableResult
    public func currencyDecimalSeparator(_ value: String) -> Self {
        me.currencyDecimalSeparator = value
        return self
    }
    
    @discardableResult
    public func usesGroupingSeparator(_ value: Bool) -> Self {
        me.usesGroupingSeparator = value
        return self
    }
    
    @discardableResult
    public func groupingSeparator(_ value: String) -> Self {
        me.groupingSeparator = value
        return self
    }
    
    @discardableResult
    public func zeroSymbol(_ value: String?) -> Self {
        me.zeroSymbol = value
        return self
    }
    
    
    
//
//    open var textAttributesForZero: [String : Any]?
//
//    open var nilSymbol: String
//
//    open var textAttributesForNil: [String : Any]?
//
//    open var notANumberSymbol: String!
//
//    open var textAttributesForNotANumber: [String : Any]?
//
//    open var positiveInfinitySymbol: String
//
//    open var textAttributesForPositiveInfinity: [String : Any]?
//
//    open var negativeInfinitySymbol: String
//
//    open var textAttributesForNegativeInfinity: [String : Any]?
//
//    open var positivePrefix: String!
//
//    open var positiveSuffix: String!
//
//    open var negativePrefix: String!
//
//    open var negativeSuffix: String!
//
//    open var currencyCode: String!
//
//    open var currencySymbol: String!
//
//    open var internationalCurrencySymbol: String!
//
//    open var percentSymbol: String!
//
//    open var perMillSymbol: String!
//
//    open var minusSign: String!
//
//    open var plusSign: String!
//
//    open var exponentSymbol: String!
//
//    open var groupingSize: Int
//
//    open var secondaryGroupingSize: Int
//
//    @NSCopying open var multiplier: NSNumber?
//
//    open var formatWidth: Int
//
//    open var paddingCharacter: String!
//
//    
//    open var paddingPosition: NumberFormatter.PadPosition
//
//    open var roundingMode: NumberFormatter.RoundingMode
//
//    @NSCopying open var roundingIncrement: NSNumber!
//
//    open var minimumIntegerDigits: Int
//
//    open var maximumIntegerDigits: Int
//
//    open var minimumFractionDigits: Int
//
//    open var maximumFractionDigits: Int
//
//    @NSCopying open var minimum: NSNumber?
//
//    @NSCopying open var maximum: NSNumber?
//
//    @available(iOS 2.0, *)
//    open var currencyGroupingSeparator: String!
//
//    @available(iOS 2.0, *)
//    open var isLenient: Bool
//
//    @available(iOS 2.0, *)
//    open var usesSignificantDigits: Bool
//
//    @available(iOS 2.0, *)
//    open var minimumSignificantDigits: Int
//
//    @available(iOS 2.0, *)
//    open var maximumSignificantDigits: Int
//
//    @available(iOS 2.0, *)
//    open var isPartialStringValidationEnabled: Bool

}

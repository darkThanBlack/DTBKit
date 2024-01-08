//
//  NumberFormatter+Chain.swift
//  XMKit_Example
//
//  Created by moonShadow on 2023/10/8
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
extension XMKitWrapper where Base: NumberFormatter & XMKitChainable {
    
    @discardableResult
    public func formattingContext(_ value: Formatter.Context) -> Self {
        me.formattingContext = value
        return self
    }
    
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
    
    @discardableResult
    public func textAttributesForZero(_ value: [String : Any]?) -> Self {
        me.textAttributesForZero = value
        return self
    }
    
    @discardableResult
    public func nilSymbol(_ value: String) -> Self {
        me.nilSymbol = value
        return self
    }

    @discardableResult
    public func textAttributesForNil(_ value: [String : Any]?) -> Self {
        me.textAttributesForNil = value
        return self
    }
    
    @discardableResult
    public func notANumberSymbol(_ value: String) -> Self {
        me.notANumberSymbol = value
        return self
    }
    
    @discardableResult
    public func textAttributesForNotANumber(_ value: [String : Any]?) -> Self {
        me.textAttributesForNotANumber = value
        return self
    }
    
    @discardableResult
    public func positiveInfinitySymbol(_ value: String) -> Self {
        me.positiveInfinitySymbol = value
        return self
    }
    
    @discardableResult
    public func textAttributesForPositiveInfinity(_ value: [String : Any]?) -> Self {
        me.textAttributesForPositiveInfinity = value
        return self
    }
    
    @discardableResult
    public func negativeInfinitySymbol(_ value: String) -> Self {
        me.negativeInfinitySymbol = value
        return self
    }
    
    @discardableResult
    public func textAttributesForNegativeInfinity(_ value: [String : Any]?) -> Self {
        me.textAttributesForNegativeInfinity = value
        return self
    }
    
    @discardableResult
    public func positivePrefix(_ value: String) -> Self {
        me.positivePrefix = value
        return self
    }
    
    @discardableResult
    public func positiveSuffix(_ value: String) -> Self {
        me.positiveSuffix = value
        return self
    }
    
    @discardableResult
    public func negativePrefix(_ value: String) -> Self {
        me.negativePrefix = value
        return self
    }
    
    @discardableResult
    public func negativeSuffix(_ value: String) -> Self {
        me.negativeSuffix = value
        return self
    }
    
    @discardableResult
    public func currencyCode(_ value: String) -> Self {
        me.currencyCode = value
        return self
    }
    
    @discardableResult
    public func currencySymbol(_ value: String) -> Self {
        me.currencySymbol = value
        return self
    }

    @discardableResult
    public func internationalCurrencySymbol(_ value: String) -> Self {
        me.internationalCurrencySymbol = value
        return self
    }
    
    @discardableResult
    public func percentSymbol(_ value: String) -> Self {
        me.percentSymbol = value
        return self
    }
    
    @discardableResult
    public func perMillSymbol(_ value: String) -> Self {
        me.perMillSymbol = value
        return self
    }
    
    @discardableResult
    public func minusSign(_ value: String) -> Self {
        me.minusSign = value
        return self
    }
    
    @discardableResult
    public func plusSign(_ value: String) -> Self {
        me.plusSign = value
        return self
    }

    @discardableResult
    public func exponentSymbol(_ value: String) -> Self {
        me.exponentSymbol = value
        return self
    }

    @discardableResult
    public func groupingSize(_ value: Int) -> Self {
        me.groupingSize = value
        return self
    }

    @discardableResult
    public func secondaryGroupingSize(_ value: Int) -> Self {
        me.secondaryGroupingSize = value
        return self
    }
    
    @discardableResult
    public func multiplier(_ value: NSNumber?) -> Self {
        me.multiplier = value
        return self
    }
    
    @discardableResult
    public func formatWidth(_ value: Int) -> Self {
        me.formatWidth = value
        return self
    }

    @discardableResult
    public func paddingCharacter(_ value: String) -> Self {
        me.paddingCharacter = value
        return self
    }

    @discardableResult
    public func paddingPosition(_ value: NumberFormatter.PadPosition) -> Self {
        me.paddingPosition = value
        return self
    }
    
    @discardableResult
    public func roundingMode(_ value: NumberFormatter.RoundingMode) -> Self {
        me.roundingMode = value
        return self
    }
    
    @discardableResult
    public func roundingIncrement(_ value: NSNumber) -> Self {
        me.roundingIncrement = value
        return self
    }
    
    @discardableResult
    public func minimumIntegerDigits(_ value: Int) -> Self {
        me.minimumIntegerDigits = value
        return self
    }
    
    @discardableResult
    public func maximumIntegerDigits(_ value: Int) -> Self {
        me.maximumIntegerDigits = value
        return self
    }
    
    @discardableResult
    public func minimumFractionDigits(_ value: Int) -> Self {
        me.minimumFractionDigits = value
        return self
    }
    
    @discardableResult
    public func maximumFractionDigits(_ value: Int) -> Self {
        me.maximumFractionDigits = value
        return self
    }
    
    @discardableResult
    public func minimum(_ value: NSNumber?) -> Self {
        me.minimum = value
        return self
    }
    
    @discardableResult
    public func maximum(_ value: NSNumber?) -> Self {
        me.maximum = value
        return self
    }
    
    @discardableResult
    public func currencyGroupingSeparator(_ value: String) -> Self {
        me.currencyGroupingSeparator = value
        return self
    }
    
    @discardableResult
    public func isLenient(_ value: Bool) -> Self {
        me.isLenient = value
        return self
    }
    
    @discardableResult
    public func usesSignificantDigits(_ value: Bool) -> Self {
        me.usesSignificantDigits = value
        return self
    }
    
    @discardableResult
    public func minimumSignificantDigits(_ value: Int) -> Self {
        me.minimumSignificantDigits = value
        return self
    }
    
    @discardableResult
    public func maximumSignificantDigits(_ value: Int) -> Self {
        me.maximumSignificantDigits = value
        return self
    }
    
    @discardableResult
    public func isPartialStringValidationEnabled(_ value: Bool) -> Self {
        me.isPartialStringValidationEnabled = value
        return self
    }
}

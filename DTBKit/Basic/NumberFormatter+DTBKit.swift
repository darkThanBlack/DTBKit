//
//  NumberFormatter+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/29
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

/// Def value.
extension DTBKitStaticWrapper where T: NumberFormatter {
    
    func ttt() {
        
    }
    
    ///
    public var `fixed`: DTBKitWrapper<NumberFormatter> {
        return NumberFormatter().dtb.decimal().rounded()
    }
    
    ///
    public var `multi`: DTBKitWrapper<NumberFormatter> {
        return NumberFormatter().dtb.maxDecimal().rounded()
    }
    
    ///
    public var CNY: DTBKitWrapper<NumberFormatter> {
        return fixed.split().prefix("¥")
    }
    
    ///
    public var RMB: DTBKitWrapper<NumberFormatter> {
        return multi.split().suffix("元")
    }
}

/// Fast chainable
extension DTBKitWrapper where Base: NumberFormatter {
    
    ///
    @discardableResult
    public func string(from number: NSNumber?) -> DTBKitWrapper<String>? {
        guard let value = number else { return nil }
        return me.string(from: value)?.dtb
    }
    
    ///
    @discardableResult
    public func number(from string: String?) -> DTBKitWrapper<NSNumber>? {
        guard let value = string else { return nil }
        return me.number(from: value)?.dtb
    }
    
    ///
    @discardableResult
    public func decimal(_ value: Int = 2) -> Self {
        me.numberStyle = .decimal
        me.minimumFractionDigits = value
        me.maximumFractionDigits = value
        return self
    }
    
    ///
    @discardableResult
    public func maxDecimal(_ value: Int = 2) -> Self {
        me.numberStyle = .decimal
        me.minimumFractionDigits = 0
        me.maximumFractionDigits = value
        return self
    }
    
    ///
    @discardableResult
    public func split(by group: String = ",", size: Int = 3) -> Self {
        me.usesGroupingSeparator = true
        me.groupingSeparator = group
        me.groupingSize = size
        return self
    }
    
    ///
    @discardableResult
    public func rounded(_ mode: NumberFormatter.RoundingMode = .halfUp) -> Self {
        me.roundingMode = .halfUp
        return self
    }
    
    ///
    @discardableResult
    public func `prefix`(_ positive: String, negative: String? = nil) -> Self {
        me.positivePrefix = positive
        me.negativePrefix = negative ?? positive
        return self
    }
    
    ///
    @discardableResult
    public func `suffix`(_ positive: String, _ negative: String? = nil) -> Self {
        me.positiveSuffix = positive
        me.negativeSuffix = negative ?? positive
        return self
    }
}

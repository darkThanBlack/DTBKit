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

extension DTBKitWrapper where Base: NumberFormatter {
    
    @discardableResult
    public func string(from number: NSNumber) -> DTBKitWrapper<String>? {
        return me.string(from: number)?.dtb
    }
    
    @discardableResult
    public func number(from string: String) -> DTBKitWrapper<NSNumber>? {
        return me.number(from: string)?.dtb
    }
}

extension DTBKitStaticWrapper where T: NumberFormatter {
    
    //    @available(iOS 4.0, *)
    //    open class func localizedString(from num: NSNumber, number nstyle: NumberFormatter.Style) -> String
    //
    //    open class func defaultFormatterBehavior() -> NumberFormatter.Behavior
    //
    //    open class func setDefaultFormatterBehavior(_ behavior: NumberFormatter.Behavior)
}

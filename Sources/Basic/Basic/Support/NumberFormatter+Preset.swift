//
//  NumberFormatter+Preset.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/11/17
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// Preset formatter
///
/// 通过静态方法提供一些预置格式。
///
/// For example:
/// ```
///     let a = 2.1.dtb.toString(.dtb.CNY)?.value
///     // a == "¥2.10"
/// ```
extension DTBKitStaticWrapper where T: NumberFormatter {
    
    ///
    public var `fixed`: NumberFormatter {
        return NumberFormatter().dtb.decimal().rounded().value
    }
    
    ///
    public var `multi`: NumberFormatter {
        return NumberFormatter().dtb.maxDecimal().rounded().value
    }
    
    ///
    public var CNY: NumberFormatter {
        return NumberFormatter().dtb.decimal().rounded().split().prefix("¥").value
    }
    
    ///
    public var RMB: NumberFormatter {
        return NumberFormatter().dtb.maxDecimal().rounded().split().suffix("元").value
    }
}

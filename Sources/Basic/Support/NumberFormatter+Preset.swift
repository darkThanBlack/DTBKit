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
///     /// "¥2.10"
///     let a = 2.1.dtb.toString(.dtb.CNY)?.value
/// ```
extension DTBKitStaticWrapper where T: NumberFormatter {
    
    /// Decimal formatter | 等长小数转换
    ///
    /// e.g.
    /// ```
    ///     2.1.dtb.toString(.dtb.decimal()).value == "2.10"
    ///
    /// ```
    ///
    /// - Parameters:
    ///   - value: decimal digits | 小数位数
    ///   - splitGroup: splitGroup | 分隔符
    ///   - splitSize: splitSize | 分隔位数
    ///   - rounded: rounded | 进位
    ///   - prefix: prefix | 前缀(不分正负)
    ///   - suffix: suffix | 后缀(不分正负)
    public func decimal(
        _ value: Int = 2,
        splitGroup: String? = nil,
        splitSize: Int = 3,
        rounded: NumberFormatter.RoundingMode = .halfUp,
        prefix: String? = nil,
        suffix: String? = nil
    ) -> NumberFormatter {
        return NumberFormatter().dtb
            .decimal(value)
            .whenNotNull(splitGroup, { data, me in
                me.dtb.split(by: data, size: splitSize)
            })
            .rounded(rounded)
            .whenNotNull(prefix, { data, me in
                me.dtb.prefix(data)
            })
            .whenNotNull(suffix, { data, me in
                me.dtb.suffix(data)
            })
            .value
    }
    
    /// Max decimal formatter | 去零小数转换
    ///
    /// - Parameters:
    ///   - value: decimal digits | 小数位数
    ///   - splitGroup: splitGroup | 分隔符
    ///   - splitSize: splitSize | 分隔位数
    ///   - rounded: rounded | 进位
    ///   - prefix: prefix | 前缀(不分正负)
    ///   - suffix: suffix | 后缀(不分正负)
    public func maxDecimal(
        _ value: Int = 2,
        splitGroup: String? = nil,
        splitSize: Int = 3,
        rounded: NumberFormatter.RoundingMode = .halfUp,
        prefix: String? = nil,
        suffix: String? = nil
    ) -> NumberFormatter {
        return NumberFormatter().dtb
            .maxDecimal(value)
            .whenNotNull(splitGroup, { data, me in
                me.dtb.split(by: data, size: splitSize)
            })
            .rounded(rounded)
            .whenNotNull(prefix, { data, me in
                me.dtb.prefix(data)
            })
            .whenNotNull(suffix, { data, me in
                me.dtb.suffix(data)
            })
            .value
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

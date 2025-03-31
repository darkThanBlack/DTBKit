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

/// Preset formatter
///
/// 通过静态方法提供一些预置格式。
///
/// For example:
/// ```
///     /// "¥2.10"
///     let a = 2.1.dtb.toString(.dtb.CNY)?.value
/// ```
extension StaticWrapper where T: NumberFormatter {
    
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
            .when(splitGroup?.isEmpty != true, { me in
                me.dtb.split(by: splitGroup ?? "", size: splitSize)
            })
            .rounded(rounded)
            .when(prefix?.isEmpty != true, { me in
                me.dtb.prefix(prefix ?? "")
            })
            .when(suffix?.isEmpty != true, { me in
                me.dtb.prefix(suffix ?? "")
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
            .when(splitGroup?.isEmpty != true, { me in
                me.dtb.split(by: splitGroup ?? "", size: splitSize)
            })
            .rounded(rounded)
            .when(prefix?.isEmpty != true, { me in
                me.dtb.prefix(prefix ?? "")
            })
            .when(suffix?.isEmpty != true, { me in
                me.dtb.prefix(suffix ?? "")
            })
            .value
    }
    
    ///
    @inline(__always)
    public func CNY() -> NumberFormatter {
        return NumberFormatter().dtb.decimal().rounded().split().prefix("¥").value
    }
    
    ///
    @inline(__always)
    public func RMB() -> NumberFormatter {
        return NumberFormatter().dtb.maxDecimal().rounded().split().suffix("元").value
    }
}

/// Fast chainable
extension Wrapper where Base: NumberFormatter {
    
    ///
    @inline(__always)
    @discardableResult
    public func string(from number: NSNumber?) -> Wrapper<String>? {
        guard let value = number else { return nil }
        return me.string(from: value)?.dtb
    }
    
    ///
    @inline(__always)
    @discardableResult
    public func number(from string: String?) -> Wrapper<NSNumber>? {
        guard let value = string else { return nil }
        return me.number(from: value)?.dtb
    }
    
    ///
    @inline(__always)
    @discardableResult
    public func decimal(_ value: Int = 2) -> Self {
        me.numberStyle = .decimal
        me.minimumFractionDigits = value
        me.maximumFractionDigits = value
        return self
    }
    
    ///
    @inline(__always)
    @discardableResult
    public func maxDecimal(_ value: Int = 2) -> Self {
        me.numberStyle = .decimal
        me.minimumFractionDigits = 0
        me.maximumFractionDigits = value
        return self
    }
    
    ///
    @inline(__always)
    @discardableResult
    public func split(by group: String = ",", size: Int = 3) -> Self {
        me.usesGroupingSeparator = true
        me.groupingSeparator = group
        me.groupingSize = size
        return self
    }
    
    ///
    @inline(__always)
    @discardableResult
    public func rounded(_ mode: NumberFormatter.RoundingMode = .halfUp) -> Self {
        me.roundingMode = .halfUp
        return self
    }
    
    ///
    @inline(__always)
    @discardableResult
    public func `prefix`(_ positive: String, negative: String? = nil) -> Self {
        me.positivePrefix = positive
        me.negativePrefix = negative ?? positive
        return self
    }
    
    ///
    @inline(__always)
    @discardableResult
    public func `suffix`(_ positive: String, _ negative: String? = nil) -> Self {
        me.positiveSuffix = positive
        me.negativeSuffix = negative ?? positive
        return self
    }
}

//
//  NumberFormatterConfig.swift
//  DTBKit
//
//  Created by moonShadow on 2025/8/12
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import Foundation

extension DTB {

    /// 对应 ``NumberFormatter``，通过 self.hash 自动缓存，避免业务重复创建相同的 NumberFormatter
    ///
    /// 所有字段均为 Optional：
    /// - `nil` → 不设置，formatter 使用系统默认值
    /// - 非 nil → 构建 formatter 时显式写入
    ///
    /// - Important: 以下 NumberFormatter 属性因类型为 `[String: Any]?`（不可 Hash），
    ///   暂不纳入本配置。如需使用请自行创建原生 NumberFormatter：
    ///   - textAttributesForNegativeValues
    ///   - textAttributesForPositiveValues
    ///   - textAttributesForZero
    ///   - textAttributesForNil
    ///   - textAttributesForNotANumber
    ///   - textAttributesForPositiveInfinity
    ///   - textAttributesForNegativeInfinity
    ///
    ///   以下属性的原生类型为 NSNumber?（不可 Hash），此处以 Double? 存储：
    ///   - multiplier
    ///   - roundingIncrement
    ///   - minimum
    ///   - maximum
    public struct NumberFormatterConfig: Hashable {

        // MARK: - Style & Locale

        public var numberStyle: NumberFormatter.Style?
        public var locale: Locale?
        public var formattingContext: Formatter.Context?

        // MARK: - Behavior

        public var generatesDecimalNumbers: Bool?
        public var formatterBehavior: NumberFormatter.Behavior?

        // MARK: - Format (deprecated in NumberFormatter, included for completeness)

        public var negativeFormat: String?
        public var positiveFormat: String?

        // MARK: - Parsing

        public var allowsFloats: Bool?

        // MARK: - Decimal Separator

        public var decimalSeparator: String?
        public var alwaysShowsDecimalSeparator: Bool?
        public var currencyDecimalSeparator: String?

        // MARK: - Grouping

        public var usesGroupingSeparator: Bool?
        public var groupingSeparator: String?
        public var groupingSize: Int?
        public var secondaryGroupingSize: Int?
        public var currencyGroupingSeparator: String?

        // MARK: - Symbols

        public var zeroSymbol: String?
        public var nilSymbol: String?
        public var notANumberSymbol: String?
        public var positiveInfinitySymbol: String?
        public var negativeInfinitySymbol: String?
        public var percentSymbol: String?
        public var perMillSymbol: String?
        public var minusSign: String?
        public var plusSign: String?
        public var exponentSymbol: String?

        // MARK: - Prefix / Suffix

        public var positivePrefix: String?
        public var positiveSuffix: String?
        public var negativePrefix: String?
        public var negativeSuffix: String?

        // MARK: - Currency

        public var currencyCode: String?
        public var currencySymbol: String?
        public var internationalCurrencySymbol: String?

        // MARK: - Rounding

        public var roundingMode: NumberFormatter.RoundingMode?
        /// 原生类型 `NSNumber?`，此处以 Double 存储；构建 formatter 时转为 NSNumber。
        public var roundingIncrement: Double?

        // MARK: - Integer / Fraction Digits

        public var minimumIntegerDigits: Int?
        public var maximumIntegerDigits: Int?
        public var minimumFractionDigits: Int?
        public var maximumFractionDigits: Int?

        // MARK: - Significant Digits

        public var usesSignificantDigits: Bool?
        public var minimumSignificantDigits: Int?
        public var maximumSignificantDigits: Int?

        // MARK: - Padding

        public var formatWidth: Int?
        public var paddingCharacter: String?
        public var paddingPosition: NumberFormatter.PadPosition?

        // MARK: - Multiplier

        /// 原生类型 `NSNumber?`，此处以 Double 存储；构建 formatter 时转为 NSNumber。
        public var multiplier: Double?

        // MARK: - Range

        /// 原生类型 `NSNumber?`，此处以 Double 存储；构建 formatter 时转为 NSNumber。
        public var minimum: Double?
        /// 原生类型 `NSNumber?`，此处以 Double 存储；构建 formatter 时转为 NSNumber。
        public var maximum: Double?

        // MARK: - Misc

        public var isLenient: Bool?
        public var isPartialStringValidationEnabled: Bool?

        // MARK: - Init

        public init(
            numberStyle: NumberFormatter.Style? = nil,
            locale: Locale? = nil,
            formattingContext: Formatter.Context? = nil,
            generatesDecimalNumbers: Bool? = nil,
            formatterBehavior: NumberFormatter.Behavior? = nil,
            negativeFormat: String? = nil,
            positiveFormat: String? = nil,
            allowsFloats: Bool? = nil,
            decimalSeparator: String? = nil,
            alwaysShowsDecimalSeparator: Bool? = nil,
            currencyDecimalSeparator: String? = nil,
            usesGroupingSeparator: Bool? = nil,
            groupingSeparator: String? = nil,
            groupingSize: Int? = nil,
            secondaryGroupingSize: Int? = nil,
            currencyGroupingSeparator: String? = nil,
            zeroSymbol: String? = nil,
            nilSymbol: String? = nil,
            notANumberSymbol: String? = nil,
            positiveInfinitySymbol: String? = nil,
            negativeInfinitySymbol: String? = nil,
            percentSymbol: String? = nil,
            perMillSymbol: String? = nil,
            minusSign: String? = nil,
            plusSign: String? = nil,
            exponentSymbol: String? = nil,
            positivePrefix: String? = nil,
            positiveSuffix: String? = nil,
            negativePrefix: String? = nil,
            negativeSuffix: String? = nil,
            currencyCode: String? = nil,
            currencySymbol: String? = nil,
            internationalCurrencySymbol: String? = nil,
            roundingMode: NumberFormatter.RoundingMode? = nil,
            roundingIncrement: Double? = nil,
            minimumIntegerDigits: Int? = nil,
            maximumIntegerDigits: Int? = nil,
            minimumFractionDigits: Int? = nil,
            maximumFractionDigits: Int? = nil,
            usesSignificantDigits: Bool? = nil,
            minimumSignificantDigits: Int? = nil,
            maximumSignificantDigits: Int? = nil,
            formatWidth: Int? = nil,
            paddingCharacter: String? = nil,
            paddingPosition: NumberFormatter.PadPosition? = nil,
            multiplier: Double? = nil,
            minimum: Double? = nil,
            maximum: Double? = nil,
            isLenient: Bool? = nil,
            isPartialStringValidationEnabled: Bool? = nil
        ) {
            self.numberStyle = numberStyle
            self.locale = locale
            self.formattingContext = formattingContext
            self.generatesDecimalNumbers = generatesDecimalNumbers
            self.formatterBehavior = formatterBehavior
            self.negativeFormat = negativeFormat
            self.positiveFormat = positiveFormat
            self.allowsFloats = allowsFloats
            self.decimalSeparator = decimalSeparator
            self.alwaysShowsDecimalSeparator = alwaysShowsDecimalSeparator
            self.currencyDecimalSeparator = currencyDecimalSeparator
            self.usesGroupingSeparator = usesGroupingSeparator
            self.groupingSeparator = groupingSeparator
            self.groupingSize = groupingSize
            self.secondaryGroupingSize = secondaryGroupingSize
            self.currencyGroupingSeparator = currencyGroupingSeparator
            self.zeroSymbol = zeroSymbol
            self.nilSymbol = nilSymbol
            self.notANumberSymbol = notANumberSymbol
            self.positiveInfinitySymbol = positiveInfinitySymbol
            self.negativeInfinitySymbol = negativeInfinitySymbol
            self.percentSymbol = percentSymbol
            self.perMillSymbol = perMillSymbol
            self.minusSign = minusSign
            self.plusSign = plusSign
            self.exponentSymbol = exponentSymbol
            self.positivePrefix = positivePrefix
            self.positiveSuffix = positiveSuffix
            self.negativePrefix = negativePrefix
            self.negativeSuffix = negativeSuffix
            self.currencyCode = currencyCode
            self.currencySymbol = currencySymbol
            self.internationalCurrencySymbol = internationalCurrencySymbol
            self.roundingMode = roundingMode
            self.roundingIncrement = roundingIncrement
            self.minimumIntegerDigits = minimumIntegerDigits
            self.maximumIntegerDigits = maximumIntegerDigits
            self.minimumFractionDigits = minimumFractionDigits
            self.maximumFractionDigits = maximumFractionDigits
            self.usesSignificantDigits = usesSignificantDigits
            self.minimumSignificantDigits = minimumSignificantDigits
            self.maximumSignificantDigits = maximumSignificantDigits
            self.formatWidth = formatWidth
            self.paddingCharacter = paddingCharacter
            self.paddingPosition = paddingPosition
            self.multiplier = multiplier
            self.minimum = minimum
            self.maximum = maximum
            self.isLenient = isLenient
            self.isPartialStringValidationEnabled = isPartialStringValidationEnabled
        }
        
        // MARK: - 构建 formatter

        /// 获取对应配置的 NumberFormatter 实例（带缓存）。
        ///
        /// 以 `self` 为 key 查 `DTB.app` 中的缓存字典；
        /// 命中则直接返回，未命中则创建并缓存。
        ///
        /// 线程安全：`DTB.app` 有锁
        public func make() -> NumberFormatter {
            let cacheKey = DTB.ConstKey<[NumberFormatterConfig: NumberFormatter]>("dtb.formatter.number.cache", useLock: true)
            var cache = DTB.app.get(cacheKey) ?? [:]
            if let cached = cache[self] {
                return cached
            }
            let f = NumberFormatter()
            apply(to: f)
            cache[self] = f
            DTB.app.set(cache, key: cacheKey)
            return f
        }

        /// 将当前配置写入目标 formatter。
        ///
        /// - 原生 Optional 的属性：直接透传，`nil` 也会写入（即清空目标值）。
        /// - 原生非 Optional 的属性：仅非 nil 时写入。
        public func apply(to f: NumberFormatter) {

            // MARK: 原生 Optional — 直接透传，nil 视为「清空」

            // Locale
            f.locale = locale

            // Format (deprecated)
            f.negativeFormat = negativeFormat
            f.positiveFormat = positiveFormat

            // Decimal Separator
            f.decimalSeparator = decimalSeparator
            f.currencyDecimalSeparator = currencyDecimalSeparator

            // Grouping
            f.groupingSeparator = groupingSeparator
            f.currencyGroupingSeparator = currencyGroupingSeparator

            // Symbols (nullable)
            f.zeroSymbol = zeroSymbol
            f.notANumberSymbol = notANumberSymbol
            f.percentSymbol = percentSymbol
            f.perMillSymbol = perMillSymbol
            f.minusSign = minusSign
            f.plusSign = plusSign
            f.exponentSymbol = exponentSymbol

            // Prefix / Suffix
            f.positivePrefix = positivePrefix
            f.positiveSuffix = positiveSuffix
            f.negativePrefix = negativePrefix
            f.negativeSuffix = negativeSuffix

            // Currency
            f.currencyCode = currencyCode
            f.currencySymbol = currencySymbol
            f.internationalCurrencySymbol = internationalCurrencySymbol

            // Padding
            f.paddingCharacter = paddingCharacter

            // MARK: 原生 Optional<NSNumber> — map 后透传（config 存 Double?）

            f.multiplier = multiplier.map { NSNumber(value: $0) }
            f.minimum = minimum.map { NSNumber(value: $0) }
            f.maximum = maximum.map { NSNumber(value: $0) }
            f.roundingIncrement = roundingIncrement.map { NSNumber(value: $0) }

            // MARK: 原生非 Optional — 仅非 nil 时写入

            // Style & Locale
            if let v = numberStyle { f.numberStyle = v }
            if let v = formattingContext { f.formattingContext = v }

            // Behavior
            if let v = generatesDecimalNumbers { f.generatesDecimalNumbers = v }
            if let v = formatterBehavior { f.formatterBehavior = v }

            // Parsing
            if let v = allowsFloats { f.allowsFloats = v }

            // Decimal Separator
            if let v = alwaysShowsDecimalSeparator { f.alwaysShowsDecimalSeparator = v }

            // Grouping
            if let v = usesGroupingSeparator { f.usesGroupingSeparator = v }
            if let v = groupingSize { f.groupingSize = v }
            if let v = secondaryGroupingSize { f.secondaryGroupingSize = v }

            // Symbols (非 Optional String，头文件 nullability 不统一导致)
            if let v = nilSymbol { f.nilSymbol = v }
            if let v = positiveInfinitySymbol { f.positiveInfinitySymbol = v }
            if let v = negativeInfinitySymbol { f.negativeInfinitySymbol = v }

            // Rounding
            if let v = roundingMode { f.roundingMode = v }

            // Integer / Fraction Digits
            if let v = minimumIntegerDigits { f.minimumIntegerDigits = v }
            if let v = maximumIntegerDigits { f.maximumIntegerDigits = v }
            if let v = minimumFractionDigits { f.minimumFractionDigits = v }
            if let v = maximumFractionDigits { f.maximumFractionDigits = v }

            // Significant Digits
            if let v = usesSignificantDigits { f.usesSignificantDigits = v }
            if let v = minimumSignificantDigits { f.minimumSignificantDigits = v }
            if let v = maximumSignificantDigits { f.maximumSignificantDigits = v }

            // Padding
            if let v = formatWidth { f.formatWidth = v }
            if let v = paddingPosition { f.paddingPosition = v }

            // Misc
            if let v = isLenient { f.isLenient = v }
            if let v = isPartialStringValidationEnabled { f.isPartialStringValidationEnabled = v }
        }
    }
}

// MARK: - Static 预置（对应 StaticWrapper，快速创建对象）

extension DTB.NumberFormatterConfig {

    /// 等长小数格式。
    ///
    /// - Parameters:
    ///   - value: 小数位数，默认 2
    ///   - splitGroup: 分组分隔符，nil 或空则不分组
    ///   - splitSize: 分组位数，默认 3
    ///   - rounded: 进位模式，默认 halfUp
    ///   - prefix: 前缀（不分正负）
    ///   - suffix: 后缀（不分正负）
    public static func decimal(
        _ value: Int = 2,
        splitGroup: String? = nil,
        splitSize: Int = 3,
        rounded: NumberFormatter.RoundingMode = .halfUp,
        prefix: String? = nil,
        suffix: String? = nil
    ) -> Self {
        var c = Self()
        c.decimal(value)
        c.rounded(rounded)
        if let g = splitGroup, !g.isEmpty {
            c.split(by: g, size: splitSize)
        }
        if let p = prefix, !p.isEmpty {
            c.prefix(p)
        }
        if let s = suffix, !s.isEmpty {
            c.suffix(s)
        }
        return c
    }

    /// 去零小数格式（末尾零省略）。
    ///
    /// - Parameters:
    ///   - value: 最大小数位数，默认 2
    ///   - splitGroup: 分组分隔符，nil 或空则不分组
    ///   - splitSize: 分组位数，默认 3
    ///   - rounded: 进位模式，默认 halfUp
    ///   - prefix: 前缀（不分正负）
    ///   - suffix: 后缀（不分正负）
    public static func maxDecimal(
        _ value: Int = 2,
        splitGroup: String? = nil,
        splitSize: Int = 3,
        rounded: NumberFormatter.RoundingMode = .halfUp,
        prefix: String? = nil,
        suffix: String? = nil
    ) -> Self {
        var c = Self()
        c.maxDecimal(value)
        c.rounded(rounded)
        if let g = splitGroup, !g.isEmpty {
            c.split(by: g, size: splitSize)
        }
        if let p = prefix, !p.isEmpty {
            c.prefix(p)
        }
        if let s = suffix, !s.isEmpty {
            c.suffix(s)
        }
        return c
    }

    /// 人民币 ¥ 格式 — "¥1,234.56"
    public static func CNY() -> Self {
        decimal(splitGroup: ",", prefix: "¥")
    }

    /// 人民币「元」格式 — "1,234.56元"
    public static func RMB() -> Self {
        maxDecimal(splitGroup: ",", suffix: "元")
    }
}

// MARK: - 实例便捷（对应 Wrapper，快速赋值 / 转换）

extension DTB.NumberFormatterConfig {

    /// 数字 → 字符串（null-safe，内部走缓存 formatter）。
    public func string(from number: NSNumber?) -> String? {
        guard let n = number else { return nil }
        return make().string(from: n)
    }

    /// 字符串 → 数字（null-safe，内部走缓存 formatter）。
    public func number(from string: String?) -> NSNumber? {
        guard let s = string else { return nil }
        return make().number(from: s)
    }

    /// 等长小数：小数位数固定为 value。
    public mutating func decimal(_ value: Int = 2) {
        numberStyle = .decimal
        minimumFractionDigits = value
        maximumFractionDigits = value
    }

    /// 去零小数：最多 value 位，末尾零省略。
    public mutating func maxDecimal(_ value: Int = 2) {
        numberStyle = .decimal
        minimumFractionDigits = 0
        maximumFractionDigits = value
    }

    /// 分组分隔。
    public mutating func split(by group: String = ",", size: Int = 3) {
        usesGroupingSeparator = true
        groupingSeparator = group
        groupingSize = size
    }

    /// 进位模式。
    public mutating func rounded(_ mode: NumberFormatter.RoundingMode = .halfUp) {
        roundingMode = mode
    }

    /// 正/负前缀。
    public mutating func `prefix`(_ positive: String, negative: String? = nil) {
        positivePrefix = positive
        negativePrefix = negative ?? positive
    }

    /// 正/负后缀。
    public mutating func `suffix`(_ positive: String, _ negative: String? = nil) {
        positiveSuffix = positive
        negativeSuffix = negative ?? positive
    }
}

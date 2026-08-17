//
//  NumberModuleTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2025-12-16
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  数字模块测试：NSDecimalNumber, NumberConvert, NSNumber, NumberFormatter
//

import XCTest

/// For code coverage.
//#if canImport(DTBKit)
//import DTBKit
//#elseif canImport(DTBKit_Basic)
//import DTBKit_Basic
//#endif

/// DTBKit 数字模块测试
final class NumberModuleTests: XCTestCase {
    
    private static let plan_int64: [Int64] = [
        0,
        1,
        -1,
        1000000,
        -1000000,
        1000000000,
        -1000000000,
        1000000000000,
        -1000000000000,
        9223372036854775807,   // Int64.max
        -9223372036854775808,  // Int64.min
        9223372036854775806,   // Int64.max - 1
        -9223372036854775807   // Int64.min + 1
    ]
    
    private static let plan_double: [Double] =  [
        0.0,
        1.0,
        -1.0,
        3.1415926,
        -3.1415926,
        1.1,
        10.01,
        100.001,
        1000.0001,
        -10.01,
        -100.001,
        -1000.0001
    ]
    
    private static let plan_double_sp: [Double] = [
        Double.zero,
        Double.infinity,
        -Double.infinity,
        Double.nan,
        Double.pi,
        Double.leastNormalMagnitude,    // 最小正规化数
        Double.leastNonzeroMagnitude,   // 最小非零数
        Double.greatestFiniteMagnitude, // 最大有限数
        Double.ulpOfOne,                // 1.0的ULP
        1.0 + Double.ulpOfOne,          // 大于1的最小数
        1.0 - Double.ulpOfOne/2         // 小于1的最大数
    ]
    
    private static let plan_not_a_number: [String] = [
        "",                   // 空字符串
        "   ",                // 多个空格
        "12 34",              // 内部空格
        " \t\n ",             // 混合空白字符
        "+",                  // 只有符号
        "-",                  // 只有负号
        ".",                  // 只有小数点
        "..",                 // 多个小数点
        "+-123",              // 多个符号
        "--123"               // 多个负号
    ]
    
    // MARK: - Convert
    
    func testNumberForceConvert() throws {
        Self.plan_int64.forEach({
            XCTAssertEqual($0.dtb.intValue(), Int($0))
            XCTAssertEqual($0.dtb.int64Value(), Int64($0))
            XCTAssertEqual($0.dtb.string().value, "\($0)")
            XCTAssertEqual($0.dtb.nsNumber().value, NSNumber(value: $0))
            XCTAssertEqual($0.dtb.nsNumber().value, "\($0)".dtb.nsNumber()?.value)
            XCTAssertEqual($0.dtb.nsDecimal().value, NSDecimalNumber(value: $0))
            XCTAssertEqual($0.dtb.nsDecimal().value, "\($0)".dtb.nsDecimal().value)
        })
        
        Self.plan_double.forEach({
            XCTAssertEqual($0.dtb.doubleValue(), Double($0))
            XCTAssertEqual($0.dtb.int().value, Int($0))
            XCTAssertEqual($0.dtb.int64().value, Int64($0))
            XCTAssertEqual($0.dtb.string().value, "\($0)")
            XCTAssertEqual($0.dtb.nsNumber().value, NSNumber(value: $0))
            XCTAssertEqual($0.dtb.nsNumber().value, "\($0)".dtb.nsNumber()?.value)
            XCTAssertEqual($0.dtb.nsDecimal().value, NSDecimalNumber(value: $0))
            XCTAssertEqual($0.dtb.nsDecimal().value, "\($0)".dtb.nsDecimal().value)
        })
        
        Self.plan_double_sp.forEach({
            XCTAssertEqual($0.dtb.string().value, "\($0)")
        })
        
        Self.plan_not_a_number.forEach({
            XCTAssertNil($0.dtb.double()?.value)
            XCTAssertNil($0.dtb.nsNumber()?.value)
            XCTAssertEqual($0.dtb.nsDecimal().value, NSDecimalNumber(string: $0))
        })
    }
    
    // MARK: - NSDecimalNumber Extensions Tests
    
    func testNSDecimalNumberBasicOperations() throws {
        let decimal1 = "10.5".dtb.nsDecimal().value
        let decimal2 = "3.2".dtb.nsDecimal().value
        
        // 测试基础运算
        let sum = decimal1.dtb.plus(decimal2).value
        XCTAssertEqual(sum.doubleValue, 13.7, accuracy: 0.001)
        
        let difference = decimal1.dtb.minus(decimal2).value
        XCTAssertEqual(difference.doubleValue, 7.3, accuracy: 0.001)
        
        let product = decimal1.dtb.multi(decimal2).value
        XCTAssertEqual(product.doubleValue, 33.6, accuracy: 0.001)
        
        let quotient = decimal1.dtb.div(decimal2).value
        XCTAssertEqual(quotient.doubleValue, 3.28125, accuracy: 0.001)
    }
    
    func testNSDecimalNumberAdvancedOperations() throws {
        let base = NSDecimalNumber(string: "2.5")
        
        // 幂运算
        let power = base.dtb.power(3).value
        XCTAssertEqual(power.doubleValue, 15.625, accuracy: 0.001)
        
        // 10的幂乘法
        let multiPower10 = base.dtb.multiPower10(2).value
        XCTAssertEqual(multiPower10.doubleValue, 250.0, accuracy: 0.001)
    }
    
    func testNSDecimalNumberConversions() throws {
        let decimal = NSDecimalNumber(string: "123.456")
        
        // 转换为基本类型
        XCTAssertEqual(decimal.dtb.double()!.value, 123.456, accuracy: 0.001)
        XCTAssertEqual(decimal.dtb.string()!.value, "123.456")
    }
    
    func testNSDecimalNumberCustomBehavior() throws {
        let decimal1 = NSDecimalNumber(string: "10")
        let decimal2 = NSDecimalNumber(string: "3")
        
        // 自定义 scale 和 rounding
        let result1 = decimal1.dtb.div(decimal2, scale: 2, rounding: .down).value
        XCTAssertEqual(result1.stringValue, "3.33")
        
        let result2 = decimal1.dtb.div(decimal2, scale: 2, rounding: .up).value
        XCTAssertEqual(result2.stringValue, "3.34")
    }
    
    func testNSDecimalNumberEdgeCases() throws {
        // 零值处理
        let zero = NSDecimalNumber.zero
        let nonZero = NSDecimalNumber(string: "5.5")
        
        XCTAssertEqual(zero.dtb.plus(nonZero).value.doubleValue, 5.5)
        XCTAssertEqual(nonZero.dtb.minus(nonZero).value, NSDecimalNumber.zero)
        XCTAssertEqual(zero.dtb.multi(nonZero).value, NSDecimalNumber.zero)
        
        // 除零检查（应该返回 NaN 或抛出异常）
        let divByZeroResult = nonZero.dtb.div(zero).value
        XCTAssertTrue(divByZeroResult.doubleValue.isNaN || divByZeroResult.doubleValue.isInfinite)
        
        // 非常大的数字
        let largeNumber = NSDecimalNumber(string: "999999999999999999999")
        XCTAssertNotNil(largeNumber)
        XCTAssertEqual(largeNumber.dtb.string()?.value, "999999999999999999999")
        
        // 非常小的数字
        let smallNumber = NSDecimalNumber(string: "0.000000000000001")
        XCTAssertNotNil(smallNumber)
        XCTAssertTrue(smallNumber.dtb.double()?.value ?? 0 > 0)
    }
    
    // MARK: - NumberConvert Extensions Tests
    
    func testIntegerConversions() throws {
        // String -> Int
        XCTAssertEqual("123".dtb.int()?.value, 123)
        XCTAssertEqual("-456".dtb.int()?.value, -456)
        XCTAssertEqual("0".dtb.int()?.value, 0)
        XCTAssertEqual("abc".dtb.int()?.value, nil) // 无效字符串返回0
        XCTAssertEqual("".dtb.int()?.value, nil) // 空字符串返回0
        
        // String -> Int64
        XCTAssertEqual("9223372036854775807".dtb.int64()?.value, Int64.max)
        XCTAssertEqual("-9223372036854775808".dtb.int64()?.value, Int64.min)
    }
    
    func testDoubleConversions() throws {
        // String -> Double
        XCTAssertEqual("3.14159".dtb.double()!.value, 3.14159, accuracy: 0.00001)
        XCTAssertEqual("-2.718".dtb.double()!.value, -2.718, accuracy: 0.001)
        XCTAssertEqual("0.0".dtb.double()!.value, 0.0)
        XCTAssertTrue("invalid".dtb.double()?.value == nil)
        
        // Double -> String
        XCTAssertEqual((3.14159).dtb.string().value, "3.14159")
        XCTAssertEqual((-2.718).dtb.string().value, "-2.718")
        XCTAssertEqual((0.0).dtb.string().value, "0.0")
        
        // Double -> NSDecimalNumber
        let doubleValue = 123.456
        let decimal = doubleValue.dtb.nsDecimal().value
        XCTAssertEqual(decimal.doubleValue, doubleValue, accuracy: 0.001)
    }
    
    func testNumberTypeConversions() throws {
        // Int -> 其他类型
        let intValue = 42
        XCTAssertEqual(intValue.dtb.int64Value(), Int64(42))
        XCTAssertEqual(intValue.dtb.double().value, 42.0)
        XCTAssertEqual(intValue.dtb.string().value, "42")
        
        // Double -> 其他类型
        let doubleValue = 3.8
        XCTAssertEqual(doubleValue.dtb.rounded(rule: .down).value, 3.0)
        XCTAssertEqual(doubleValue.dtb.rounded(rule: .up).value, 4.0)
        XCTAssertEqual(doubleValue.dtb.rounded(rule: .toNearestOrEven).value, 4.0)
    }
    
    func testPrecisionOperations() throws {
        let precisionValue = 1.23456789
        
        // 测试各种舍入模式
        XCTAssertEqual(precisionValue.dtb.rounded(rule: .down).value, 1.0)
        XCTAssertEqual(precisionValue.dtb.rounded(rule: .up).value, 2.0)
        XCTAssertEqual(precisionValue.dtb.rounded(rule: .towardZero).value, 1.0)
        XCTAssertEqual(precisionValue.dtb.rounded(rule: .awayFromZero).value, 2.0)
        
        let negativeValue = -1.23456789
        XCTAssertEqual(negativeValue.dtb.rounded(rule: .down).value, -2.0)
        XCTAssertEqual(negativeValue.dtb.rounded(rule: .up).value, -1.0)
    }
    
    func testNumberConversionEdgeCases() throws {
        // 边界值测试
        XCTAssertEqual(Int.max.dtb.string().value, String(Int.max))
        XCTAssertEqual(Int.min.dtb.string().value, String(Int.min))
        
        // 浮点数特殊值
        XCTAssertTrue(Double.nan.dtb.string().value.contains("nan"))
        XCTAssertTrue(Double.infinity.dtb.string().value.contains("inf"))
        XCTAssertTrue((-Double.infinity).dtb.string().value.contains("inf"))
        
        // 科学计数法
        let scientificString = "1.23e10"
        let scientificValue = scientificString.dtb.double()?.value ?? 0
        XCTAssertEqual(scientificValue, 12300000000.0, accuracy: 1.0)
        
        // 十六进制字符串（应该返回0或NaN）
        let hexString = "0xFF"
        let hexValue = hexString.dtb.int()?.value
        XCTAssertEqual(hexValue, nil) // 默认实现可能不支持十六进制
    }
    
    // MARK: - NSNumber Extensions Tests
    
    func testNSNumberConversions() throws {
        // NSNumber -> 基本类型
        let nsNumber = NSNumber(value: 123.45)
        
        XCTAssertEqual(nsNumber.dtb.int().value, 123)
        XCTAssertEqual(nsNumber.dtb.int64().value, Int64(123))
        XCTAssertEqual(nsNumber.dtb.double().value, 123.45, accuracy: 0.01)
        
        // 布尔值 NSNumber
        let boolNumber = NSNumber(value: true)
        XCTAssertEqual(boolNumber.dtb.int().value, 1)
        XCTAssertEqual(boolNumber.dtb.double().value, 1.0)
        
        let falseBoolNumber = NSNumber(value: false)
        XCTAssertEqual(falseBoolNumber.dtb.int().value, 0)
        XCTAssertEqual(falseBoolNumber.dtb.double().value, 0.0)
    }
    
    func testNSNumberEdgeCases() throws {
        // 极大值
        let maxNumber = NSNumber(value: Double.greatestFiniteMagnitude)
        XCTAssertTrue(maxNumber.dtb.double().value > 0)
        
        // 极小值
        let minNumber = NSNumber(value: -Double.greatestFiniteMagnitude)
        XCTAssertTrue(minNumber.dtb.double().value < 0)
        
        // 零值
        let zeroNumber = NSNumber(value: 0)
        XCTAssertEqual(zeroNumber.dtb.int().value, 0)
        XCTAssertEqual(zeroNumber.dtb.double().value, 0.0)
    }
    
    // MARK: - NumberFormatterConfig Tests

    /// 固定 en_US_POSIX locale，保证小数点为 "."、分组为 ","，让断言确定。
    private func posixDecimal(_ digits: Int = 2) -> DTB.NumberFormatterConfig {
        var c = DTB.NumberFormatterConfig()
        c.locale = Locale(identifier: "en_US_POSIX")
        c.decimal(digits)
        return c
    }

    func testNumberFormatterConfigDecimal() throws {
        // 等长小数：固定小数位数，不足补零
        XCTAssertEqual(posixDecimal(2).string(from: NSNumber(value: 3.1)), "3.10")
        // halfUp 进位
        XCTAssertEqual(posixDecimal(3).string(from: NSNumber(value: 3.14159)), "3.142")
    }

    func testNumberFormatterConfigMaxDecimal() throws {
        var c = DTB.NumberFormatterConfig()
        c.locale = Locale(identifier: "en_US_POSIX")
        c.maxDecimal(3)

        // 去零小数：末尾零省略
        XCTAssertEqual(c.string(from: NSNumber(value: 1.5)), "1.5")
        // halfUp 进位
        XCTAssertEqual(c.string(from: NSNumber(value: 1.23456789)), "1.235")
    }

    func testNumberFormatterConfigGrouping() throws {
        var c = DTB.NumberFormatterConfig()
        c.locale = Locale(identifier: "en_US_POSIX")
        c.decimal(2)
        c.split(by: ",", size: 3)

        XCTAssertEqual(c.string(from: NSNumber(value: 1234567.89)), "1,234,567.89")
    }

    func testNumberFormatterConfigRounding() throws {
        let n = NSNumber(value: 1.235)

        let down = DTB.NumberFormatterConfig.decimal(2, rounded: .down)
        let up = DTB.NumberFormatterConfig.decimal(2, rounded: .up)

        // 不同舍入模式产生不同结果
        XCTAssertNotEqual(down.string(from: n), up.string(from: n))
    }

    func testNumberFormatterConfigPrefixSuffix() throws {
        let n = NSNumber(value: 100)

        let prefixed = DTB.NumberFormatterConfig.decimal(2, prefix: "$").string(from: n)
        let suffixed = DTB.NumberFormatterConfig.decimal(2, suffix: "%").string(from: n)

        XCTAssertNotNil(prefixed)
        XCTAssertNotNil(suffixed)
        XCTAssertTrue(prefixed!.hasPrefix("$"))
        XCTAssertTrue(suffixed!.hasSuffix("%"))
    }

    func testNumberFormatterConfigPreset() throws {
        let n = NSNumber(value: 12.34)

        let cny = DTB.NumberFormatterConfig.CNY().string(from: n)
        let rmb = DTB.NumberFormatterConfig.RMB().string(from: n)

        XCTAssertNotNil(cny)
        XCTAssertNotNil(rmb)
        XCTAssertTrue(cny!.hasPrefix("¥"))
        XCTAssertTrue(rmb!.hasSuffix("元"))
    }

    func testNumberFormatterConfigNullSafe() throws {
        let c = DTB.NumberFormatterConfig.decimal(2)

        XCTAssertNil(c.string(from: nil))
        XCTAssertNil(c.number(from: nil))
        XCTAssertNil(c.number(from: ""))
    }

    func testNumberFormatterConfigCache() throws {
        // 值相等的配置命中同一缓存实例
        let a = DTB.NumberFormatterConfig.decimal(2)
        let b = DTB.NumberFormatterConfig.decimal(2)

        XCTAssertEqual(a, b)
        XCTAssertTrue(a.make() === b.make())
    }

    func testNumberFormatterConfigApplyClearOptional() throws {
        // 原生 Optional 属性：apply(to:) 里 nil 会「清空」目标 formatter 的已有值
        let formatter = NumberFormatter()

        // 1. 先设置 multiplier = 100
        var set = DTB.NumberFormatterConfig()
        set.multiplier = 100
        set.apply(to: formatter)
        XCTAssertEqual(formatter.multiplier?.doubleValue, 100)

        // 2. 再用一个 multiplier = nil 的 config 覆盖，应清空
        var clear = DTB.NumberFormatterConfig()
        clear.multiplier = nil
        clear.apply(to: formatter)
        XCTAssertNil(formatter.multiplier)
    }

    func testNumberFormatterConfigApplyPreserveNonOptional() throws {
        // 原生非 Optional 属性：apply(to:) 里 nil 不修改目标 formatter 的已有值
        let formatter = NumberFormatter()

        // 先设置 numberStyle = .currency
        var set = DTB.NumberFormatterConfig()
        set.numberStyle = .currency
        set.apply(to: formatter)
        XCTAssertEqual(formatter.numberStyle, .currency)

        // 再用一个 numberStyle = nil 的 config 覆盖，应保留原值（不修改）
        var skip = DTB.NumberFormatterConfig()
        skip.numberStyle = nil
        skip.apply(to: formatter)
        XCTAssertEqual(formatter.numberStyle, .currency)
    }
}

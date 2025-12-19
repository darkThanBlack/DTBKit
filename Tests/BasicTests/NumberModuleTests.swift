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
#if canImport(DTBKit)
import DTBKit
#elseif canImport(DTBKit_Basic)
import DTBKit_Basic
#endif

/// DTBKit 数字模块测试
final class NumberModuleTests: XCTestCase {

    // MARK: - NSDecimalNumber Extensions Tests

    func testNSDecimalNumberBasicOperations() throws {
        let decimal1 = "10.5".dtb.nsDecimal()!.value
        let decimal2 = "3.2".dtb.nsDecimal()!.value

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
        XCTAssertEqual("abc".dtb.int()?.value, 0) // 无效字符串返回0
        XCTAssertEqual("".dtb.int()?.value, 0) // 空字符串返回0

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
        XCTAssertEqual(doubleValue.dtb.rounded(.down).value, 3.0)
        XCTAssertEqual(doubleValue.dtb.rounded(.up).value, 4.0)
        XCTAssertEqual(doubleValue.dtb.rounded(.toNearestOrEven).value, 4.0)
    }

    func testPrecisionOperations() throws {
        let precisionValue = 1.23456789

        // 测试各种舍入模式
        XCTAssertEqual(precisionValue.dtb.rounded(.down).value, 1.0)
        XCTAssertEqual(precisionValue.dtb.rounded(.up).value, 2.0)
        XCTAssertEqual(precisionValue.dtb.rounded(.towardZero).value, 1.0)
        XCTAssertEqual(precisionValue.dtb.rounded(.awayFromZero).value, 2.0)

        let negativeValue = -1.23456789
        XCTAssertEqual(negativeValue.dtb.rounded(.down).value, -2.0)
        XCTAssertEqual(negativeValue.dtb.rounded(.up).value, -1.0)
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
        XCTAssertEqual(hexValue, 0) // 默认实现可能不支持十六进制
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

    // MARK: - NumberFormatter Extensions Tests

    func testNumberFormatterBasicFormatting() throws {
        let formatter = NumberFormatter()

        // 基础数字格式化
        let number = NSNumber(value: 1234.56)
        let basicFormatted = formatter.dtb.string(from: number)?.value
        XCTAssertNotNil(basicFormatted)
        XCTAssertTrue(basicFormatted!.contains("1"))

        // number(from:) 方法测试
        let numberFromString = formatter.dtb.number(from: "1234.56")?.value
        XCTAssertNotNil(numberFromString)
        XCTAssertEqual(numberFromString!.doubleValue, 1234.56, accuracy: 0.01)
    }

    func testNumberFormatterDecimalConfiguration() throws {
        let formatter = NumberFormatter()

        // 测试小数位配置链式调用
        let formattedDecimal = formatter.dtb
            .decimal(2)
            .string(from: NSNumber(value: 3.14159))?.value

        XCTAssertNotNil(formattedDecimal)
        // 具体格式取决于区域设置，但应该包含小数点
        XCTAssertTrue(formattedDecimal!.contains(".") || formattedDecimal!.contains(","))
    }

    func testNumberFormatterMaxDecimalConfiguration() throws {
        let formatter = NumberFormatter()

        // 测试最大小数位配置
        let maxDecimalFormatted = formatter.dtb
            .maxDecimal(3)
            .string(from: NSNumber(value: 1.23456789))

        XCTAssertNotNil(maxDecimalFormatted)
        // 应该不超过3位小数
    }

    func testNumberFormatterGroupingSeparator() throws {
        let formatter = NumberFormatter()

        // 测试千分位分隔符
        let groupedNumber = formatter.dtb
            .split(by: ",", size: 3)
            .string(from: NSNumber(value: 1234567))

        XCTAssertNotNil(groupedNumber)
        // 根据配置，应该包含分组分隔符
    }

    func testNumberFormatterRoundingMode() throws {
        let formatter = NumberFormatter()
        let testNumber = NSNumber(value: 1.235)

        // 测试不同舍入模式
        let roundedDown = formatter.dtb
            .rounded(.down)
            .decimal(2)
            .string(from: testNumber)?.value

        let roundedUp = formatter.dtb
            .rounded(.up)
            .decimal(2)
            .string(from: testNumber)?.value

        XCTAssertNotNil(roundedDown)
        XCTAssertNotNil(roundedUp)
        XCTAssertNotEqual(roundedDown, roundedUp) // 不同舍入模式应该产生不同结果
    }

    func testNumberFormatterPrefixSuffix() throws {
        let formatter = NumberFormatter()
        let testNumber = NSNumber(value: 100)

        // 测试前缀和后缀
        let prefixed = formatter.dtb
            .prefix("$")
            .string(from: testNumber)?.value

        let suffixed = formatter.dtb
            .suffix("%")
            .string(from: testNumber)?.value

        XCTAssertNotNil(prefixed)
        XCTAssertNotNil(suffixed)
        XCTAssertTrue(prefixed!.hasPrefix("$"))
        XCTAssertTrue(suffixed!.hasSuffix("%"))
    }

    func testNumberFormatterPresetFormats() throws {
        // 测试预置格式
        let testNumber = NSNumber(value: 12.34)

        // CNY 格式
        let cnyFormatted = NumberFormatter.dtb.CNY().string(from: testNumber)
        XCTAssertNotNil(cnyFormatted)

        // RMB 格式
        let rmbFormatted = NumberFormatter.dtb.RMB().string(from: testNumber)
        XCTAssertNotNil(rmbFormatted)
    }

    func testNumberFormatterComplexChaining() throws {
        let formatter = NumberFormatter()
        let complexNumber = NSNumber(value: 1234567.89123)

        // 复杂链式配置
        let complexFormatted = formatter.dtb
            .decimal(2)
            .split(by: ",", size: 3)
            .rounded(.halfEven)
            .prefix("Total: $")
            .suffix(" USD")
            .string(from: complexNumber)?.value

        XCTAssertNotNil(complexFormatted)
        XCTAssertTrue(complexFormatted!.contains("$"))
        XCTAssertTrue(complexFormatted!.contains("USD"))
    }

    func testNumberFormatterInvalidInputs() throws {
        let formatter = NumberFormatter()

        // 无效字符串解析
        let invalidNumber = formatter.dtb.number(from: "invalid123")
        XCTAssertNil(invalidNumber)

        // 空字符串
        let emptyNumber = formatter.dtb.number(from: "")
        XCTAssertNil(emptyNumber)

        // 特殊字符
        let specialCharNumber = formatter.dtb.number(from: "12#34$56")
        // 取决于 formatter 的 lenient 设置，可能返回 nil 或部分解析结果
    }
}

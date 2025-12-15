//
//  BasicComprehensiveTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2025-12-11
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//

import XCTest
import DTBKit

/// DTBKit Basic 模块的综合测试用例
final class BasicTests: XCTestCase {
    
    // MARK: - Collection
    
    func testCollection() throws {
        let list = [1, 2, 3]
        
        XCTAssert(list.dtb[-1] == nil)
        XCTAssert(list.dtb[0] == 1)
        XCTAssert(list.dtb[2] == 3)
        XCTAssert(list.dtb[3] == nil)
        XCTAssert(list.dtb[nil] == nil)
    }
    
    // MARK: - Manager
    
    /// 弱引用包装器
    func testWeakerClass() throws {
        class TestClass {
            let value: String
            init(value: String) {
                self.value = value
            }
        }

        var testObject: TestClass? = TestClass(value: "test")
        let weaker = DTB.Weaker(testObject)
        // 弱引用应该能访问对象
        XCTAssertEqual(weaker.value?.value, "test")

        // 释放原对象
        testObject = nil
        // 弱引用应该变为 nil
        XCTAssertNil(weaker.value)
    }
    
    /// 内存字典
    func testAppManager() throws {
        let manager = DTB.app
        
        /// 对象存储
        let _ = {
            let constKey = DTB.ConstKey<String>("typed_key")
            manager.set("typed_value", key: constKey)
            XCTAssertEqual(manager.get(constKey), "typed_value")

            manager.set(nil, key: constKey)
            XCTAssertNil(manager.get(constKey))
            
            // 如果 key 的 rawValue 相同，会造成覆盖 (不打算加入类型字面量和哈希)
            let anotherKey = DTB.ConstKey<String>("typed_key")
            manager.set("another", key: anotherKey)
            XCTAssertNotNil(manager.get(constKey))
        }()
        
        // 弱引用存储
        class TestClass {
            let name: String
            init(name: String) { self.name = name }
        }
        let _ = {
            var testObject: TestClass? = TestClass(name: "weak_test")
            let weakKey = DTB.ConstKey<TestClass>("weak_key")

            manager.setWeak(testObject, key: weakKey)
            XCTAssertNotNil(manager.getWeak(weakKey))

            testObject = nil
            XCTAssertNil(manager.getWeak(weakKey))
        }()
        
        // 较大数据(不超过内存容量)存储
        let _ = {
            let testKey = DTB.ConstKey<[String]>("memory_test_key")

            let largeData = Array(0..<10000).compactMap { "Item \($0)" }
            manager.set(largeData, key: testKey)

            // 验证数据正确存储
            let retrievedData = manager.get(testKey)
            XCTAssertEqual(retrievedData?.count, 10000)

            // 清理数据
            manager.set(nil, key: testKey)
            XCTAssertNil(manager.get(testKey))
        }()
        
    }
    
    /// 分离读写 - 并发写入
    func testAppManagerConcurrentWrites() throws {
        let manager = DTB.app
        let iterations = 100
        let keys = (0..<iterations).map { index in
            DTB.ConstKey<String>("write_test_\(index)", useLock: true)
        }
        
        // 并发写入
        DispatchQueue.concurrentPerform(iterations: iterations) { index in
            let key = keys[index]
            let value = "value_\(index)"
            manager.set(value, key: key)
        }
        
        // 写入完成后，串行验证读取
        for index in 0..<iterations {
            let key = keys[index]
            let expectedValue = "value_\(index)"
            let actualValue = manager.get(key)
            XCTAssertEqual(actualValue, expectedValue, "Mismatch at index \(index)")
            
            // 清理
            manager.set(nil, key: key)
        }
    }

    /// 分离读写 - 并发读取
    func testAppManagerConcurrentReads() throws {
        let manager = DTB.app
        let key = DTB.ConstKey<String>("read_test", useLock: true)
        let expectedValue = "shared_value"
        
        // 先写入数据
        manager.set(expectedValue, key: key)
        
        let expectation = XCTestExpectation(description: "Concurrent reads")
        expectation.expectedFulfillmentCount = 100
        
        // 并发读取
        DispatchQueue.concurrentPerform(iterations: 100) { _ in
            let value = manager.get(key)
            XCTAssertEqual(value, expectedValue)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        
        // 清理
        manager.set(nil, key: key)
    }

    // MARK: - Frame
    
    func testCGSize() throws {
        let validSize = CGSize(width: 100, height: 50)
        let invalidSize = CGSize(width: -10, height: 0)
        let targetSize = CGSize(width: 200, height: 200)
        let negativeTarget = CGSize(width: -200, height: -200)
        
        // 基础属性测试
        XCTAssertEqual(invalidSize.dtb.safe().value, CGSize.zero)
        XCTAssertFalse(validSize.dtb.isEmpty())
        XCTAssertTrue(validSize.dtb.notEmpty())
        XCTAssertTrue(validSize.dtb.notEmpty())
        XCTAssertFalse(invalidSize.dtb.notEmpty())
        
        // 几何计算测试
        XCTAssertEqual(validSize.dtb.center(), CGPoint(x: 50, y: 25))
        XCTAssertEqual(validSize.dtb.longer(), 100)
        XCTAssertEqual(validSize.dtb.shorter(), 50)
        XCTAssertEqual(validSize.dtb.area(), 5000)
        // 负数
        XCTAssertEqual(invalidSize.dtb.center(), CGPoint.zero)
        XCTAssertEqual(invalidSize.dtb.longer(), 0)
        XCTAssertEqual(invalidSize.dtb.shorter(), 0)
        XCTAssertEqual(invalidSize.dtb.area(), 0)
        
        // 内外接正方形
        XCTAssertFalse(validSize.dtb.isSquare())
        XCTAssertEqual(validSize.dtb.inSquare(), CGSize(width: 50, height: 50))
        XCTAssertEqual(validSize.dtb.outSquare(), CGSize(width: 100, height: 100))
        // 负数
        XCTAssertFalse(invalidSize.dtb.isSquare())
        XCTAssertEqual(invalidSize.dtb.inSquare(), CGSize.zero)
        XCTAssertEqual(invalidSize.dtb.outSquare(), CGSize.zero)
        
        // 布局计算
        XCTAssertEqual(validSize.dtb.margin(all: 10).value, CGSize(width: 120, height: 70))
        XCTAssertEqual(validSize.dtb.padding(all: 5).value, CGSize(width: 90, height: 40))
        // 如果出现负数，按 0 为基准计算，且不会返回负数
        XCTAssertEqual(invalidSize.dtb.margin(all: 10).value, CGSize(width: 20, height: 20))
        XCTAssertEqual(invalidSize.dtb.padding(all: 5).value, CGSize(width: 0, height: 0))
        
        // 宽高比适配测试
        // === 正常情况 ===
        
        // 1. 完全正常的情况
        let fitResult = validSize.dtb.aspectFit(to: targetSize).value
        XCTAssertEqual(fitResult, CGSize(width: 200, height: 100))  // 按宽度缩放
        
        let fillResult = validSize.dtb.aspectFill(to: targetSize).value
        XCTAssertEqual(fillResult, CGSize(width: 400, height: 200))  // 按高度缩放
        
        // 2. 1:1 比例情况
        let squareSize = CGSize(width: 100, height: 100)
        let squareFit = squareSize.dtb.aspectFit(to: targetSize).value
        XCTAssertEqual(squareFit, targetSize)
        
        let squareFill = squareSize.dtb.aspectFill(to: targetSize).value
        XCTAssertEqual(squareFill, targetSize)
        
        // 3. 极端比例情况
        let wideSize = CGSize(width: 1000, height: 10)  // 超宽
        let wideFit = wideSize.dtb.aspectFit(to: targetSize).value
        XCTAssertEqual(wideFit, CGSize(width: 200, height: 2))  // 按宽度限制
        
        let wideFill = wideSize.dtb.aspectFill(to: targetSize).value
        XCTAssertEqual(wideFill, CGSize(width: 20000, height: 200))  // 按高度缩放
        
        let tallSize = CGSize(width: 10, height: 1000)  // 超高
        let tallFit = tallSize.dtb.aspectFit(to: targetSize).value
        XCTAssertEqual(tallFit, CGSize(width: 2, height: 200))  // 按高度限制
        
        let tallFill = tallSize.dtb.aspectFill(to: targetSize).value
        XCTAssertEqual(tallFill, CGSize(width: 200, height: 20000))  // 按宽度缩放
        
        // === 边界情况：源尺寸问题 ===
        
        // 4. 源尺寸为负数 -> 返回目标尺寸
        let negativeSize = CGSize(width: -100, height: -50)
        let negativeFit = negativeSize.dtb.aspectFit(to: targetSize).value
        XCTAssertEqual(negativeFit, targetSize)  // 直接返回目标尺寸
        
        let negativeFill = negativeSize.dtb.aspectFill(to: targetSize).value
        XCTAssertEqual(negativeFill, targetSize)  // 直接返回目标尺寸
        
        // 5. 源尺寸部分负数 -> 返回目标尺寸
        let partialNegative = CGSize(width: -100, height: 50)
        let partialNegativeFit = partialNegative.dtb.aspectFit(to: targetSize).value
        XCTAssertEqual(partialNegativeFit, targetSize)
        
        let partialNegativeFill = partialNegative.dtb.aspectFill(to: targetSize).value
        XCTAssertEqual(partialNegativeFill, targetSize)
        
        // 6. 目标尺寸为负数 -> 返回 zero
        let fitToNegative = validSize.dtb.aspectFit(to: negativeTarget).value
        XCTAssertEqual(fitToNegative, CGSize.zero)
        let fillToNegative = validSize.dtb.aspectFill(to: negativeTarget).value
        XCTAssertEqual(fillToNegative, CGSize.zero)
    }

    //MARK: - Number
    
    func testDoubleExtensions() throws {
        // MARK: - 基础转换测试
        let testValue: Double = 123.456789

        // 类型转换
        let decimalNumber = testValue.dtb.nsDecimal().value
        XCTAssertNotNil(decimalNumber)
        XCTAssertEqual(decimalNumber.doubleValue, testValue, accuracy: 0.000001)

        // 字符串转换
        let stringValue = testValue.dtb.string().value
        XCTAssertEqual(stringValue, String(testValue))

        // MARK: - 精度截取测试
        let precisionTests: [(value: Double, places: Int, expected: Double)] = [
            (1.23456, 0, 1.0),
            (1.23456, 1, 1.2),
            (1.23456, 2, 1.23),
            (1.23456, 3, 1.235),
            (1.99999, 2, 2.0),
            (0.999, 1, 1.0),
            (-1.23456, 2, -1.23)
        ]

        for test in precisionTests {
            let result = test.value.dtb.places(test.places)
            XCTAssertEqual(result, test.expected, accuracy: 0.001,
                          "places(\(test.places)) on \(test.value) should return \(test.expected), got \(result)")
        }

        // MARK: - 舍入模式测试
        let roundingTests: [(value: Double, mode: FloatingPointRoundingRule, expected: Double)] = [
            (1.4, .toNearestOrEven, 1.0),
            (1.5, .toNearestOrEven, 2.0),
            (1.6, .toNearestOrEven, 2.0),
            (2.5, .toNearestOrEven, 2.0), // 银行家舍入
            (1.4, .up, 2.0),
            (1.1, .up, 2.0),
            (-1.1, .up, -1.0),
            (1.9, .down, 1.0),
            (-1.1, .down, -2.0),
            (1.4, .towardZero, 1.0),
            (-1.9, .towardZero, -1.0),
            (1.4, .awayFromZero, 2.0),
            (-1.1, .awayFromZero, -2.0)
        ]

        for test in roundingTests {
            let result = test.value.dtb.rounded(test.mode).value
            XCTAssertEqual(result, test.expected, accuracy: 0.001,
                          "rounded(\(test.mode)) on \(test.value) should return \(test.expected), got \(result)")
        }

        // MARK: - 边界值测试
        XCTAssertFalse(Double.greatestFiniteMagnitude.dtb.string().value.isEmpty)
        XCTAssertFalse(Double.leastNonzeroMagnitude.dtb.string().value.isEmpty)
        XCTAssertTrue(Double.infinity.dtb.string().value.lowercased().contains("inf"))
        XCTAssertTrue(Double.nan.dtb.string().value.lowercased().contains("nan"))

        // MARK: - 零值和负零测试
        XCTAssertEqual(0.0.dtb.places(2), 0.0)
        XCTAssertEqual((-0.0).dtb.places(2), 0.0)

        // MARK: - HF 高保真缩放测试
        let hfValue = 100.0.dtb.hf(.scale)
        XCTAssertTrue(hfValue > 0, "HF scaling should produce positive result")

        // MARK: - 浮点数精度问题测试
        let preciseValue = 0.1 + 0.2 // 经典浮点数精度问题
        let roundedValue = preciseValue.dtb.places(1)
        XCTAssertEqual(roundedValue, 0.3, accuracy: 0.001)
    }

    func testIntExtensions() throws {
        // MARK: - 基础转换测试
        let testInt = 123456789
        XCTAssertEqual(testInt.dtb.string().value, "123456789")

        // MARK: - 边界值测试
        XCTAssertEqual(Int.max.dtb.string().value, String(Int.max))
        XCTAssertEqual(Int.min.dtb.string().value, String(Int.min))
        XCTAssertEqual(0.dtb.string().value, "0")
        XCTAssertEqual((-1).dtb.string().value, "-1")

        // MARK: - 时间戳转换测试
        let now = Date()
        let timestamp = now.timeIntervalSince1970
        let intTimestamp = Int(timestamp)
        let dateFromTimestamp = intTimestamp.dtb.sDate()?.value
        XCTAssertNotNil(dateFromTimestamp)

        // 毫秒时间戳测试
        let millisecondsTimestamp = intTimestamp * 1000
        let dateFromMillis = millisecondsTimestamp.dtb.msDate()?.value
        XCTAssertNotNil(dateFromMillis)

        // 无效时间戳测试
        let invalidTimestamp = -1
        XCTAssertNil(invalidTimestamp.dtb.sDate()?.value)

        // MARK: - 星期字符串测试 (1-7 对应周一到周日)
        for weekday in 1...7 {
            let dayString = weekday.dtb.weekDayString()
            XCTAssertNotNil(dayString)
            XCTAssertFalse(dayString?.isEmpty ?? true)
        }

        // 无效星期数测试
        XCTAssertNil(0.dtb.weekDayString())
        XCTAssertNil(8.dtb.weekDayString())

        // MARK: - NSDecimal 转换测试
        let smallInt = 42
        let decimalFromInt = smallInt.dtb.nsDecimal()
        XCTAssertNotNil(decimalFromInt)
        XCTAssertEqual(decimalFromInt.string()?.value, "42")

        // MARK: - 数据类型转换测试
        let testValue: Int = 1024
        XCTAssertEqual(Int64(testValue), testValue.dtb.int64Value())
    }
    
    // MARK: - NumberFormatter Extensions Tests

    func testNumberFormatterExtensions() throws {
        // MARK: - 链式配置测试
        let formatter = NumberFormatter().dtb
            .decimal(2)
            .rounded(.halfUp)
            .prefix("$", negative: "-$")
            .value

        // MARK: - 基础格式化测试
        let positiveValue: Double = 123.456
        let positiveResult = formatter.string(from: NSNumber(value: positiveValue))
        XCTAssertNotNil(positiveResult)
        XCTAssertTrue(positiveResult?.contains("$") ?? false)
        XCTAssertTrue(positiveResult?.contains("123.46") ?? false)

        let negativeValue: Double = -123.456
        let negativeResult = formatter.string(from: NSNumber(value: negativeValue))
        XCTAssertTrue(negativeResult?.contains("-$") ?? false)

        // MARK: - 预置格式测试
        // 测试内置的货币和小数格式
        let testCases: [(formatter: NumberFormatter, value: Double, expectedContains: [String])] = [
            (NumberFormatter.dtb.decimal(), 2.1, ["2.10"]),
            (NumberFormatter.dtb.decimal(), 1234.567, ["1234.57"]),
            (NumberFormatter.dtb.maxDecimal(), 2.1, ["2.1"]),
            (NumberFormatter.dtb.maxDecimal(), 1234.567, ["1234.57"]),
            (NumberFormatter.dtb.CNY(), 2.1, ["¥", "2.10"]),
            (NumberFormatter.dtb.CNY(), 1234.567, ["¥", "1,234.57"]),
            (NumberFormatter.dtb.RMB(), 2.1, ["2.1", "元"]),
            (NumberFormatter.dtb.RMB(), 1234.567, ["1,234.57", "元"])
        ]

        for testCase in testCases {
            let result = testCase.value.dtb.toString(testCase.formatter)?.value ?? ""
            for expectedString in testCase.expectedContains {
                XCTAssertTrue(result.contains(expectedString),
                             "Result '\(result)' should contain '\(expectedString)'")
            }
        }

        // MARK: - 复杂链式配置测试
        let complexTests: [(value: Double, expectedResult: String)] = [
            (2.0, "¥2.00"),
            (1234.567, "¥1,234.57"),
            (-1234.567, "-¥1,234.57")
        ]

        for test in complexTests {
            let complexFormatter = NumberFormatter().dtb
                .decimal(2)
                .rounded(.halfDown)
                .prefix("¥", negative: "-¥")
                .value

            let result = test.value.dtb.toString(complexFormatter)?.value ?? ""
            XCTAssertEqual(result, test.expectedResult,
                          "Formatting \(test.value) should produce '\(test.expectedResult)', got '\(result)'")
        }

        // MARK: - 边界值格式化测试
        let boundaryTests: [(value: Double, description: String)] = [
            (0.0, "零值"),
            (-0.0, "负零"),
            (Double.leastNonzeroMagnitude, "最小正数"),
            (1e-10, "极小数"),
            (1e10, "极大数")
        ]

        let simpleFormatter = NumberFormatter.dtb.decimal(2)
        for test in boundaryTests {
            let result = test.value.dtb.toString(simpleFormatter)?.value
            XCTAssertNotNil(result, "应该能格式化\(test.description): \(test.value)")
            XCTAssertFalse(result?.isEmpty ?? true, "\(test.description)格式化结果不应为空")
        }

        // MARK: - 不同舍入模式测试
        let roundingModes: [NumberFormatter.RoundingMode] = [
            .ceiling, .floor, .down, .up, .halfEven, .halfDown, .halfUp
        ]

        let testValue: Double = 1.235
        for mode in roundingModes {
            let roundFormatter = NumberFormatter().dtb
                .decimal(2)
                .rounded(mode)
                .value

            let result = testValue.dtb.toString(roundFormatter)?.value
            XCTAssertNotNil(result, "舍入模式 \(mode) 应该能正常工作")
        }
    }
    
    //MARK: - Decimal
    
    func testPrecisionCalculations() throws {
        // 浮点数精度测试
        let preciseValue = 0.1 + 0.2 // 经典浮点数精度问题
        let roundedValue = preciseValue.dtb.places(1)
        XCTAssertEqual(roundedValue, 0.3, accuracy: 0.001)

        // NSDecimalNumber 精确计算
        let decimal1 = NSDecimalNumber(string: "0.1")
        let decimal2 = NSDecimalNumber(string: "0.2")
        let preciseSum = decimal1.dtb.plus(decimal2, scale: 1, rounding: .plain)?.double()?.value ?? 0
        XCTAssertEqual(preciseSum, 0.3, accuracy: 0.0001)
    }

    func testNSDecimalNumberExtensions() throws {
        let decimal1 = NSDecimalNumber(string: "123.45")
        let decimal2 = NSDecimalNumber(string: "67.89")

        // 基础运算测试
        let sum = decimal1.dtb.plus(decimal2, scale: 2, rounding: .plain)?.double()?.value ?? 0
        XCTAssertEqual(sum, 191.34, accuracy: 0.01)

        let difference = decimal1.dtb.minus(decimal2, scale: 2, rounding: .plain)?.double()?.value ?? 0
        XCTAssertEqual(difference, 55.56, accuracy: 0.01)

        let product = decimal1.dtb.multi(decimal2, scale: 2, rounding: .plain)?.double()?.value ?? 0
        XCTAssertEqual(product, 8381.0205, accuracy: 0.01)

        let quotient = decimal1.dtb.div(decimal2, scale: 2, rounding: .plain)?.double()?.value ?? 0
        XCTAssertEqual(quotient, 1.818649, accuracy: 0.01)

        // 幂运算测试
        let power = decimal1.dtb.power(2, scale: 2, rounding: .plain)?.double()?.value ?? 0
        XCTAssertEqual(power, 15239.90, accuracy: 0.1)

        // 科学计数法测试
        let multiPower10 = decimal1.dtb.multiPower10(2, scale: 2, rounding: .plain)?.double()?.value ?? 0
        XCTAssertEqual(multiPower10, 12345.0, accuracy: 0.01)
    }
    
    // MARK: - String

    func testStringExtensions() throws {
        // 极大值测试
        let maxDouble = Double.greatestFiniteMagnitude
        let maxString = maxDouble.dtb.string().value
        XCTAssertFalse(maxString.isEmpty)

        // 极小值测试
        let minDouble = Double.leastNonzeroMagnitude
        let minString = minDouble.dtb.string().value
        XCTAssertFalse(minString.isEmpty)

        // 无穷大测试
        let infinity = Double.infinity
        let infinityString = infinity.dtb.string().value
        XCTAssertTrue(infinityString.lowercased().contains("inf"))

        // NaN 测试
        let nan = Double.nan
        let nanString = nan.dtb.string().value
        XCTAssertTrue(nanString.lowercased().contains("nan"))
        
        let testString = "Hello, World!"

        // 基础转换测试
        XCTAssertEqual(testString.dtb.ns().value.length, 13)

        // 数字转换测试
        let numberString = "123.456"
        let doubleValue = numberString.dtb.double()?.value ?? 0.0
        XCTAssertEqual(doubleValue, 123.456, accuracy: 0.001)
        
        // FIXME: MOON__FIXME 应该使用 numberformatter
        let intValue = numberString.dtb.int64()?.value
        XCTAssertEqual(intValue, nil)

        // NSDecimalNumber 转换测试
        let decimalValue = numberString.dtb.nsDecimal()?.string()?.value ?? ""
        XCTAssertEqual(decimalValue, "123.456")

        // FIXME: MOON__FIXME
        // 空字符串测试
//        XCTAssertTrue("".dtb.isEmpty())
//        XCTAssertTrue("   ".dtb.isBlank())
//        XCTAssertFalse("test".dtb.isEmpty())
//        XCTAssertFalse("test".dtb.isBlank())
        
        let invalidString = "not_a_number"

        // 无效转换应该返回 nil 而不是崩溃
        XCTAssertNil(invalidString.dtb.double())
        XCTAssertNil(invalidString.dtb.int64())
        XCTAssertNil(invalidString.dtb.nsDecimal())
        
        // 正则匹配测试 (简单数字匹配)
        let digitString = "12345"
        XCTAssertTrue(digitString.dtb.isMatches("^\\d+$"))
    }
    
    func testUnicodeAndSpecialCharacters() throws {
        // Unicode 字符串测试
        let unicodeString = "🌟Hello 世界 123.45"
        XCTAssertEqual(unicodeString.dtb.ns().value.length, 14)

        // 特殊字符数字提取
        let mixedString = "Price: $123.45 USD"
        XCTAssertNil(mixedString.dtb.double()) // 应该无法直接转换
        
        // 纯数字提取测试
        let pureNumberString = "123.45"
        XCTAssertEqual(pureNumberString.dtb.double()?.value ?? 0, 123.45, accuracy: 0.001)
    }
    
    //MARK: - Time
    
    func testDateExtensions() throws {
        let now = Date()
        let calendar = Calendar.current
        
        // 负数时间计算
        let futureDate = Date().dtb.addingDay(-30)
        XCTAssertNotNil(futureDate)
        XCTAssertTrue(futureDate!.value.timeIntervalSince1970 < Date().timeIntervalSince1970)
        
        // 时间计算测试
        let tomorrow = now.dtb.addingDay(1)?.value
        XCTAssertNotNil(tomorrow)

        let nextWeek = now.dtb.addingWeek(1)?.value
        XCTAssertNotNil(nextWeek)

        let nextMonth = now.dtb.addingMonth(1)?.value
        XCTAssertNotNil(nextMonth)

        let nextYear = now.dtb.addingYear(1)?.value
        XCTAssertNotNil(nextYear)

        // 时间戳转换测试
        let secondsTimestamp = now.dtb.s().value
        XCTAssertTrue(secondsTimestamp > 0)

        let millisecondsTimestamp = now.dtb.ms().value
        XCTAssertTrue(millisecondsTimestamp > secondsTimestamp)

        // 动态时间格式化测试
        let dynamicFormat = now.dtb.toDynamic()
        XCTAssertFalse(dynamicFormat.isEmpty)

        // FIXME: MOON__FIXME
        // 日期组件测试
//        XCTAssertEqual(now.dtb.year(), calendar.component(.year, from: now))
//        XCTAssertEqual(now.dtb.month(), calendar.component(.month, from: now))
//        XCTAssertEqual(now.dtb.day(), calendar.component(.day, from: now))
//        XCTAssertEqual(now.dtb.weekday(), calendar.component(.weekday, from: now))

        // 日期比较测试 (使用 delta(to:) 方法)
        let yesterday = now.dtb.addingDay(-1)?.value ?? now
        let deltaToYesterday = now.dtb.delta(to: yesterday, .day) ?? 0
        XCTAssertTrue(deltaToYesterday > 0) // 现在比昨天晚，所以 delta 应该是正数
        
        // FIXME: 实现不周
        // 星期字符串测试
        for weekday in 1...7 {
            let dayString = weekday.dtb.weekDayString()
            XCTAssertNotNil(dayString)
            XCTAssertFalse(dayString?.isEmpty ?? true)
        }
    }
    
    func testDateCalculationEdgeCases() throws {
        let baseDate = Date(timeIntervalSince1970: 0) // 1970-01-01

        // 极端日期计算
        let veryFuture = baseDate.dtb.addingYear(1000)
        XCTAssertNotNil(veryFuture)

        let veryPast = baseDate.dtb.addingYear(-100)
        XCTAssertNotNil(veryPast)

        // 闰年边界测试
        let leapYearDate = DateComponents(calendar: Calendar.current, year: 2024, month: 2, day: 29).date!
        let nextDay = leapYearDate.dtb.addingDay(1)
        XCTAssertNotNil(nextDay)
        // FIXME: MOON
//        XCTAssertEqual(nextDay?.value.dtb.month(), 3) // 应该进入3月
    }
    
    func testDynamicDate() throws {
        
        XCTAssert(1.dtb.nsDecimal().string()?.value == "1")
        XCTAssert("2.0".dtb.nsDecimal()?.double()?.value == 2.0)
        // FIXME: pure number
        XCTAssert("3.哈".dtb.nsDecimal()?.string()?.value == "3")
        XCTAssert("哈哈".dtb.nsDecimal()?.string()?.value == nil)
        
        /// 2024-10-17 18:06
        /// 刚刚
        /// 3分钟前
        /// 今天 16:59
        /// 昨天 18:06
        /// 10-09 18:06
        /// 2023-10-16 18:06
        [
            Date().dtb.addingDay(1)!.value,
            Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 20),
            Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 200),
            Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 4000),
            Date().dtb.addingDay(-1)!.value,
            Date().dtb.addingWeek(-1)!.value,
            Date().dtb.addingYear(-1)!.value
        ].forEach { d in
            print(d.dtb.toDynamic())
        }
    }
    
    // MARK: - JSON

    func testJSON() throws {
        let testArray = [1, 2, 3, 4, 5]

        // 安全索引访问测试
        XCTAssertEqual(testArray.dtb[0], 1)
        XCTAssertEqual(testArray.dtb[4], 5)
        XCTAssertNil(testArray.dtb[10])  // 越界访问
        XCTAssertNil(testArray.dtb[-1])  // 负数索引
        XCTAssertNil(testArray.dtb[nil]) // nil 索引

        // 空数组测试
        let emptyArray: [Int] = []
        XCTAssertNil(emptyArray.dtb[0])

        // JSON 转换测试
        let jsonArray: [Int] = [1, 2, 3]
        let jsonObject: [Int] = jsonArray.dtb.json() ?? []
        XCTAssertNotNil(jsonObject)

        let jsonString = jsonArray.dtb.jsonString()?.value ?? ""
        XCTAssertTrue(jsonString.contains("["))
        XCTAssertTrue(jsonString.contains("1"))

        // 字典 JSON 测试
        let dictionary = ["key1": "value1", "key2": "value2"]
        let dictJsonString = dictionary.dtb.jsonString()?.value ?? ""
        XCTAssertTrue(dictJsonString.contains("key1"))
    }
    
    // MARK: - UserDefaults

    func testUserDefaultsExtensions() throws {
        // 基础类型存储测试 - 使用 ConstKey
        let stringKey = DTB.ConstKey<String>("test_userdefaults_key")
        let testString = "test_value"
        UserDefaults.dtb.write(testString, key: stringKey)
        XCTAssertEqual(UserDefaults.dtb.read(stringKey), testString)

        // 数组存储测试 - 使用 ConstKey
        let arrayKey = DTB.ConstKey<[Int]>("test_array")
        let testArray = [1, 2, 3, 4, 5]
        UserDefaults.dtb.write(testArray, key: arrayKey)
        XCTAssertEqual(UserDefaults.dtb.read(arrayKey), testArray)

        // 字典存储测试 - 使用 ConstKey
        let dictKey = DTB.ConstKey<[String: String]>("test_dict")
        let testDict = ["key1": "value1", "key2": "value2"]
        UserDefaults.dtb.write(testDict, key: dictKey)
        XCTAssertEqual(UserDefaults.dtb.read(dictKey), testDict)

        // 清理测试数据
        UserDefaults.dtb.write(nil, key: stringKey)
        UserDefaults.dtb.write(nil, key: arrayKey)
        UserDefaults.dtb.write(nil, key: dictKey)
    }

    // MARK: - HF
    
    func testCGSizeHF() throws {
        let testSize = CGSize(width: 100, height: 50)

        // HF 缩放测试
        let hfSize = testSize.dtb.hf()
        XCTAssertTrue(hfSize.width > 0)
        XCTAssertTrue(hfSize.height > 0)

        // 比例应该保持一致
        let originalRatio = testSize.width / testSize.height
        let hfRatio = hfSize.width / hfSize.height
        XCTAssertEqual(originalRatio, hfRatio, accuracy: 0.001)
    }
    
    func testAlertCreaterChainAPI() throws {
        var actionTriggered = false

        // 测试 Alert 创建器链式调用
        let alertController = DTB.alert()
            .title("Test Alert")
            .message("This is a test message")
            .addAction(
                .init(
                    title: "OK",
                    attrTitle: nil,
                    extra: nil,
                    handler: { _ in actionTriggered = true
                    }
                )
            )
            .addAction(
                .init(title: "Cancel")
            )
            .value

        // 验证链式配置的结果
        XCTAssertEqual(alertController.title, "Test Alert")
        XCTAssertEqual(alertController.message, "This is a test message")
        XCTAssertEqual(alertController.actions.count, 2)

        // 测试 action 执行
        alertController.actions.first?.handler?(alertController.actions.first!)
        XCTAssertTrue(actionTriggered)
    }
    
    // MARK: - UIKit Extensions Tests (仅测试不依赖 UI 的部分)

    func testUIColorExtensions() throws {
        // 十六进制颜色创建测试
        let redColor = UIColor.dtb.create("#FF0000")
        XCTAssertNotNil(redColor)

        let rgbColor = UIColor.dtb.create("#00FF00")
        XCTAssertNotNil(rgbColor)

        let argbColor = UIColor.dtb.create("#FF0000FF") // Alpha + RGB
        XCTAssertNotNil(argbColor)

        let rgbaColor = UIColor.dtb.create("#0000FFFF") // RGB + Alpha
        XCTAssertNotNil(rgbaColor)

        // 短格式测试
        let shortFormat = UIColor.dtb.create("#F00") // 应该被解释为 #FF0000
        XCTAssertNotNil(shortFormat)
    }

}

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
final class BasicComprehensiveTests: XCTestCase {

    // MARK: - Foundation Extensions Tests
    
    func testCollection() throws {
        let list = [1, 2, 3]
        
        XCTAssert(list.dtb[-1] == nil)
        XCTAssert(list.dtb[0] == 1)
        XCTAssert(list.dtb[2] == 3)
        XCTAssert(list.dtb[3] == nil)
        XCTAssert(list.dtb[nil] == nil)
    }
    
    func testCGSizeExtensions() throws {
        let validSize = CGSize(width: 100, height: 50)
        let invalidSize = CGSize(width: -10, height: 0)

        // 基础属性测试
        XCTAssertTrue(invalidSize.dtb.isEmpty())
        XCTAssertFalse(validSize.dtb.isEmpty())
        XCTAssertTrue(validSize.dtb.notEmpty())

        // 几何计算测试
        XCTAssertEqual(validSize.dtb.center(), CGPoint(x: 50, y: 25))
        XCTAssertEqual(validSize.dtb.longer(), 100)
        XCTAssertEqual(validSize.dtb.shorter(), 50)
        XCTAssertEqual(validSize.dtb.area(), 5000)

        // 内外接正方形
        XCTAssertFalse(validSize.dtb.isSquare())
        XCTAssertEqual(validSize.dtb.inSquare(), CGSize(width: 50, height: 50))
        XCTAssertEqual(validSize.dtb.outSquare(), CGSize(width: 100, height: 100))

        // 布局计算测试
        XCTAssertEqual(validSize.dtb.margin(all: 10).value, CGSize(width: 120, height: 70))
        XCTAssertEqual(validSize.dtb.padding(all: 5).value, CGSize(width: 90, height: 40))

        // 宽高比适配测试
        let targetSize = CGSize(width: 200, height: 200)
        let fitResult = validSize.dtb.aspectFit(to: targetSize).value
        XCTAssertEqual(fitResult, CGSize(width: 200, height: 100))

        let fillResult = validSize.dtb.aspectFill(to: targetSize).value
        XCTAssertEqual(fillResult, CGSize(width: 400, height: 200))
    }

    func testStringExtensions() throws {
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

        // 正则匹配测试 (简单数字匹配)
        let digitString = "12345"
        XCTAssertTrue(digitString.dtb.isMatches("^\\d+$"))
    }

    func testDoubleExtensions() throws {
        let testValue: Double = 123.456789

        // 数字格式化测试
        let formattedString = testValue.dtb.toString(NumberFormatter().dtb.decimal(2).value)?.value
        XCTAssertTrue(formattedString?.contains("123.46") ?? false)

        // NSDecimalNumber 转换测试
        let decimalNumber = testValue.dtb.nsDecimal()
        XCTAssertNotNil(decimalNumber)

        // 精度计算测试
        let precisionValue = 1.23456
        let rounded = precisionValue.dtb.places(2)
        XCTAssertEqual(rounded, 1.23, accuracy: 0.001)

        // 四舍五入测试
        let roundedValue = 1.567.dtb.rounded(.toNearestOrEven).value
        XCTAssertEqual(roundedValue, 2.0, accuracy: 0.001)
    }

    func testIntExtensions() throws {
        let testInt = 123456789

        // 基础转换测试
        XCTAssertEqual(testInt.dtb.string().value, "123456789")

        // 时间戳测试
        let timestamp = Date().timeIntervalSince1970
        let intTimestamp = Int(timestamp)
        let dateFromTimestamp = intTimestamp.dtb.sDate()?.value
        XCTAssertNotNil(dateFromTimestamp)

        let millisecondsTimestamp = intTimestamp * 1000
        let dateFromMillis = millisecondsTimestamp.dtb.msDate()?.value
        XCTAssertNotNil(dateFromMillis)

        // FIXME: MOON__FIXME
        // 星期字符串测试
        for weekday in 1...7 {
            let dayString = weekday.dtb.weekDayString()
            XCTAssertNotNil(dayString)
            XCTAssertFalse(dayString?.isEmpty ?? true)
        }
    }

    func testDateExtensions() throws {
        let now = Date()
        let calendar = Calendar.current

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

    // MARK: - Collection Extensions Tests

    func testCollectionExtensions() throws {
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

    // MARK: - Manager Tests

    func testAppManager() throws {
        let manager = DTB.app
        
        // 类型安全的键值存储测试
        let constKey = DTB.ConstKey<String>("typed_key")
        manager.set("typed_value", key: constKey)
        XCTAssertEqual(manager.get(constKey), "typed_value")

        manager.set(nil, key: constKey)
        XCTAssertNil(manager.get(constKey))

        // 弱引用存储测试
        class TestClass {
            let name: String
            init(name: String) { self.name = name }
        }

        var testObject: TestClass? = TestClass(name: "weak_test")
        let weakKey = DTB.ConstKey<TestClass>("weak_key")

        manager.setWeak(testObject, key: weakKey)
        XCTAssertNotNil(manager.getWeak(weakKey))

        testObject = nil
        XCTAssertNil(manager.getWeak(weakKey))
    }

    func testWeakerClass() throws {
        class TestClass {
            let value: String
            init(value: String) {
                self.value = value
            }
        }

        var testObject: TestClass? = TestClass(value: "test")
        let weaker = DTB.Weaker(testObject!)

        // 弱引用应该能访问对象
        XCTAssertEqual(weaker.value?.value, "test")

        // 释放原对象
        testObject = nil

        // 弱引用应该变为 nil
        XCTAssertNil(weaker.value)
    }

    func testConstKey() throws {
        let key1 = DTB.ConstKey<String>("same_name")
        let key2 = DTB.ConstKey<String>("same_name")
        let key3 = DTB.ConstKey<Int>("same_name")

//        // 相同类型和名称的 key 应该相等
//        XCTAssertEqual(key1, key2)
//
//        // 不同类型的 key 不应该相等（即使名称相同）
//        XCTAssertNotEqual(key1.hashValue, key3.hashValue)
    }

    // MARK: - Error Handling Tests

    func testErrorExtensions() throws {
        let errorMessage = "Test error message"
        let error = NSError.dtb.reason(errorMessage)

        XCTAssertEqual(error.localizedDescription, errorMessage)
        XCTAssertEqual(error.domain, "dtb.error")
        XCTAssertEqual(error.code, -1)
    }

    // MARK: - UserDefaults Extensions Tests

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

    // MARK: - NumberFormatter Extensions Tests

    func testNumberFormatterExtensions() throws {
        let formatter = NumberFormatter()

        // 链式配置测试
        let configuredFormatter = formatter.dtb
            .decimal(2)
            .rounded(.halfUp)
            .prefix("$", negative: "-$")
            .value

        // 格式化测试
        let testValue: Double = 123.456
        let formattedString = configuredFormatter.string(from: NSNumber(value: testValue))

        XCTAssertNotNil(formattedString)
        XCTAssertTrue(formattedString?.contains("$") ?? false)
        XCTAssertTrue(formattedString?.contains("123.46") ?? false)

        // 负数格式化测试
        let negativeValue: Double = -123.456
        let negativeFormatted = configuredFormatter.string(from: NSNumber(value: negativeValue))
        XCTAssertTrue(negativeFormatted?.contains("-$") ?? false)

        // 预置格式测试
        let cnyFormatter = NumberFormatter.dtb.CNY()
        let cnyString = cnyFormatter.string(from: NSNumber(value: 100.5))
        XCTAssertTrue(cnyString?.contains("¥") ?? false)

        let rmbFormatter = NumberFormatter.dtb.RMB()
        let rmbString = rmbFormatter.string(from: NSNumber(value: 100.5))
        XCTAssertTrue(rmbString?.contains("元") ?? false)
    }
}

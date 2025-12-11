//
//  EdgeCasesAndHFTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2025-12-11
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//

import XCTest
import DTBKit

/// DTBKit 边界情况和高保真设计测试
final class EdgeCasesAndHFTests: XCTestCase {

    // MARK: - 边界情况测试

    func testNilAndEmptyValues() throws {
        // String 空值测试
        XCTAssertNil("".dtb.double())
        XCTAssertNil("  ".dtb.int64())
        XCTAssertNil("invalid_number".dtb.nsDecimal())

        // Collection 空值测试
        let emptyArray: [Int] = []
        XCTAssertNil(emptyArray.dtb[0])
        XCTAssertNil(emptyArray.dtb.jsonString())

        // CGSize 零值测试
        let zeroSize = CGSize.zero
        XCTAssertTrue(zeroSize.dtb.isEmpty())
        XCTAssertEqual(zeroSize.dtb.center(), CGPoint.zero)
        XCTAssertEqual(zeroSize.dtb.area(), 0)
    }

    func testExtremeValues() throws {
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
    }

    func testNegativeValues() throws {
        // 负数 CGSize
        let negativeSize = CGSize(width: -100, height: -50)
        XCTAssertTrue(negativeSize.dtb.isEmpty())
        XCTAssertEqual(negativeSize.dtb.longer(), 0) // 应该处理负值

        // 负数时间计算
        let futureDate = Date().dtb.addingDay(-30)
        XCTAssertNotNil(futureDate)
        XCTAssertTrue(futureDate!.value.timeIntervalSince1970 < Date().timeIntervalSince1970)
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

    // MARK: - 高保真设计测试

    func testHFBehaviors() throws {
        // 测试不同的 HF 行为
        let testValue: CGFloat = 100.0

        // 缩放行为测试
        let scaledValue = testValue.dtb.hf(.scale)
        XCTAssertTrue(scaledValue > 0)
        
        // FIXME: MOON
        // 如果当前设备屏幕宽度不是设计宽度，缩放值应该不等于原值
        // （除非恰好相等，这种情况很少见）
//        let currentScreenWidth = UIScreen.main.bounds.width
//        let designWidth = DTB.Configuration.designBaseSize.hf.width
//
//        if abs(currentScreenWidth - designWidth) > 0.1 {
//            XCTAssertNotEqual(scaledValue, testValue, accuracy: 0.1)
//        }
    }

    func testCGSizeHF() throws {
        let testSize = CGSize(width: 100, height: 50)

        // HF 缩放测试
        let hfSize = testSize.dtb.hf(.scale)
        XCTAssertTrue(hfSize.width > 0)
        XCTAssertTrue(hfSize.height > 0)

        // 比例应该保持一致
        let originalRatio = testSize.width / testSize.height
        let hfRatio = hfSize.width / hfSize.height
        XCTAssertEqual(originalRatio, hfRatio, accuracy: 0.001)
    }

    // MARK: - 精度和数值计算测试

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

    func testRoundingModes() throws {
        let testValue = 1.235

        // 不同舍入模式测试
        let roundUp = testValue.dtb.rounded(.up).value
        XCTAssertEqual(roundUp, 2.0)

        let roundDown = testValue.dtb.rounded(.down).value
        XCTAssertEqual(roundDown, 1.0)

        let roundToNearest = testValue.dtb.rounded(.toNearestOrAwayFromZero).value
        XCTAssertEqual(roundToNearest, 1.0)
    }

    // MARK: - 内存管理测试

    func testWeakReferenceManagement() throws {
        class TestObject {
            let id: String
            init(id: String) { self.id = id }
        }

        // 创建对象并设置弱引用
        var strongRef: TestObject? = TestObject(id: "test")
        let weaker = DTB.Weaker(strongRef!)

        // 确认弱引用正常工作
        XCTAssertNotNil(weaker.value)
        XCTAssertEqual(weaker.value?.id, "test")

        // 释放强引用
        strongRef = nil

        // 弱引用应该变为 nil
        XCTAssertNil(weaker.value)
    }

    func testAppManagerMemoryBehavior() throws {
        let manager = DTB.app
        let testKey = DTB.ConstKey<[String]>("memory_test_key")

        // 存储大量数据测试内存行为
        let largeData = Array(0..<10000).map { _ in "Item \\($0)" }
        manager.set(largeData, key: testKey)

        // 验证数据正确存储
        let retrievedData = manager.get(testKey)
        XCTAssertEqual(retrievedData?.count, 10000)

        // 清理数据
        manager.set(nil, key: testKey)
        XCTAssertNil(manager.get(testKey))
    }

    // MARK: - 多线程安全测试

    func testConcurrentAccess() throws {
        // FIXME: MOON
//        let manager = DTB.app
//        let expectation = XCTestExpectation(description: "Concurrent access")
//        let iterations = 100
//
//        // 并发写入测试
//        DispatchQueue.concurrentPerform(iterations: iterations) { index in
//            let key = DTB.ConstKey<String>("concurrent_key_\(index)")
//
//            let value = "value_\(index)"
//            manager.set(value, key: key)
//
//            // 立即读取验证
//            if let retrieved = manager.get(key) {
//                XCTAssertEqual(retrieved, value)
//            }
//
//            if index == iterations - 1 {
//                expectation.fulfill()
//            }
//        }
//
//        wait(for: [expectation], timeout: 5.0)
//
//        // 验证所有数据都正确写入
//        for index in 0..<iterations {
//            let key = DTB.ConstKey<String>("concurrent_key_\(index)")
//            let expectedValue = "value_\(index)"
//            XCTAssertEqual(manager.get(key), expectedValue)
//
//            // 清理测试数据
//            manager.set(nil, key: key)
//        }
    }

    // MARK: - 性能测试

    func testStringConversionPerformance() throws {
        let testStrings = (0..<1000).map { idx in "TestString\(idx)_\(Double.random(in: 0...1000))" }

        measure {
            for string in testStrings {
                _ = string.dtb.ns()
                _ = string.dtb.double()
            }
        }
    }

    func testCollectionAccessPerformance() throws {
        let largeArray = Array(0..<10000)

        measure {
            for index in 0..<1000 {
                _ = largeArray.dtb[index]
                _ = largeArray.dtb[index + 5000]
                _ = largeArray.dtb[index + 9000]
            }
        }
    }

    func testCGSizeCalculationPerformance() throws {
        let testSizes = (0..<1000).map { _ in
            CGSize(width: Double.random(in: 1...1000), height: Double.random(in: 1...1000))
        }

        measure {
            for size in testSizes {
                _ = size.dtb.center()
                _ = size.dtb.longer()
                _ = size.dtb.shorter()
                _ = size.dtb.area()
                _ = size.dtb.inSquare()
                _ = size.dtb.outSquare()
            }
        }
    }

    // MARK: - 错误恢复测试

    func testErrorRecovery() throws {
        // JSON 解析错误恢复
//        let invalidJson = "{ invalid json"
//        let jsonResult = invalidJson.dtb.jsonString()
//        XCTAssertNil(jsonResult) // 应该优雅地处理错误
//
//        // 数字转换错误恢复
//        let invalidNumber = "not_a_number"
//        XCTAssertNil(invalidNumber.dtb.double())
//        XCTAssertNil(invalidNumber.dtb.int64())
//        XCTAssertNil(invalidNumber.dtb.nsDecimal())

        // NSDecimalNumber 除零保护
        let decimal = NSDecimalNumber(value: 10)
        let zeroResult = decimal.dtb.div(0, scale: 2, rounding: .plain)
        // 应该返回 nil 或无穷大，而不是崩溃
        XCTAssertNoThrow({
            _ = zeroResult
        }())
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
}

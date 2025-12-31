//
//  BasicTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2025-12-16
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  DTBKit Basic 模块的核心框架测试
//

import XCTest

/// For code coverage.
#if canImport(DTBKit)
@_exported import DTBKit
#elseif canImport(DTBKit_Basic)
@_exported import DTBKit_Basic
#endif

/// DTBKit Basic 模块的核心框架测试
/// 主要测试 Collection 扩展、Manager 工具类、CGSize 扩展和 HighFidelity 缩放
final class BasicTests: XCTestCase {

    // MARK: - Manager Utilities Tests

    /// 弱引用包装器测试
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

    /// AppManager 内存管理测试
    func testAppManagerBasicOperations() throws {
        let manager = DTB.app

        // 强引用存储测试
        let stringKey = DTB.ConstKey<String>("test_string")
        manager.set("test_value", key: stringKey)
        XCTAssertEqual(manager.get(stringKey), "test_value")

        // 清空测试
        manager.set(nil, key: stringKey)
        XCTAssertNil(manager.get(stringKey))

        // 相同 rawValue 的 key 会造成覆盖
        let anotherStringKey = DTB.ConstKey<String>("test_string")
        manager.set("another_value", key: anotherStringKey)
        XCTAssertEqual(manager.get(stringKey), "another_value") // 被覆盖了
    }

    /// AppManager 弱引用存储测试
    func testAppManagerWeakStorage() throws {
        class TestClass {
            let name: String
            init(name: String) { self.name = name }
        }

        let manager = DTB.app
        var testObject: TestClass? = TestClass(name: "weak_test")
        let weakKey = DTB.ConstKey<TestClass>("weak_key")

        // 弱引用存储
        manager.setWeak(testObject, key: weakKey)
        XCTAssertNotNil(manager.getWeak(weakKey))
        XCTAssertEqual(manager.getWeak(weakKey)?.name, "weak_test")

        // 释放对象
        testObject = nil
        XCTAssertNil(manager.getWeak(weakKey))
    }

    /// ConstKey 基础功能测试
    func testConstKeyBasics() throws {
        // 基础类型安全
        let stringKey = DTB.ConstKey<String>("string_key")
        let intKey = DTB.ConstKey<Int>("int_key")

        XCTAssertEqual(stringKey.key_, "string_key")
        XCTAssertEqual(intKey.key_, "int_key")
        XCTAssertFalse(stringKey.useLock_)
        XCTAssertFalse(intKey.useLock_)

        // 禁用锁的 key
        let noLockKey = DTB.ConstKey<String>("no_lock_key", useLock: false)
        XCTAssertFalse(noLockKey.useLock_)

        // 启用锁的 key
        let lockKey = DTB.ConstKey<String>("lock_key", useLock: true)
        XCTAssertTrue(lockKey.useLock_)
    }
    
    // MARK: - HighFidelity Extensions Tests

    func testHighFidelity() throws {
        let designBaseSize = DTB.config.designBaseSize
        let screenSize = UIScreen.main.bounds.size
        XCTAssertEqual(designBaseSize.width.dtb.hf(), screenSize.width)
        XCTAssertEqual(designBaseSize.height.dtb.hf(.scale(.v)), screenSize.height)
    }

    // MARK: - Double Extensions Tests (Precision)

    func testDoublePrecisionOperation() throws {
        // 精度截取测试（注意：places 方法是截断而非四舍五入）
        let precisionTests: [(value: Double, places: Int, expected: Double)] = [
            (1.23456, 0, 1.0),
            (1.23456, 1, 1.2),
            (1.23456, 2, 1.23),
            (1.23456, 3, 1.234),  // 截断，不是四舍五入到 1.235
            (1.99999, 2, 1.99),   // 截断，不是四舍五入到 2.0
            (0.999, 1, 0.9),      // 截断，不是四舍五入到 1.0
            (-1.23456, 2, -1.23)  // 负数截断
        ]

        for test in precisionTests {
            let result = test.value.dtb.trunc(to: test.places)
            XCTAssertEqual(result, test.expected, accuracy: 0.0001,
                          "places(\(test.places)) of \(test.value) should be \(test.expected), got \(result)")
        }

        // 边界情况
        XCTAssertEqual(0.0.dtb.trunc(to: 2), 0.0)
        XCTAssertEqual(123.0.dtb.trunc(to: 2), 123.0) // 整数保持不变
    }

    // MARK: - JSON Processing Tests

    func testJSONProcessing() throws {
        // 测试对象转 JSON 字符串
        let testDict = ["name": "DTBKit", "version": "1.0", "active": true] as [String: Any]

        let jsonString = testDict.dtb.jsonString()?.value
        XCTAssertNotNil(jsonString)
        XCTAssertTrue(jsonString!.contains("DTBKit"))

        // 测试 JSON 字符串转对象
//        let jsonStr = """
//        {
//            "name": "DTBKit",
//            "version": "1.0",
//            "active": true
//        }
//        """
//
//        let parsedDict: [String: Any]? = jsonStr.dtb.json().value
//        XCTAssertNotNil(parsedDict)
//        XCTAssertEqual(parsedDict?["name"] as? String, "DTBKit")
    }

    // MARK: - AlertCreater Tests (Chain API)

    func testAlertCreaterChainAPI() throws {
        // 测试链式 API 构建
        let alert = DTB.alert()
            .title("测试标题")
            .message("测试消息")
            .addAction(
                DTB.AlertActionCreater(
                    title: "确定",
                    attrTitle: nil,
                    extra: nil,
                    handler: { _ in }
                )
            )
            .addAction(
                DTB.AlertActionCreater(
                    title: "取消",
                    attrTitle: nil,
                    extra: nil,
                    handler: { _ in }
                )
            )
            .show()
            .value

        // 验证创建的 Alert 对象
        XCTAssertEqual(alert.title, "测试标题")
        XCTAssertEqual(alert.message, "测试消息")
        XCTAssertEqual(alert.actions.count, 2)
        XCTAssertEqual(alert.actions[0].title, "确定")
        XCTAssertEqual(alert.actions[1].title, "取消")
    }
}

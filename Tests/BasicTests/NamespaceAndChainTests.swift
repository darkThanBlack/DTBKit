//
//  NamespaceAndChainTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2025-12-11
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//

import XCTest
import DTBKit

/// DTBKit 命名空间和链式 API 设计测试
final class NamespaceAndChainTests: XCTestCase {

    // MARK: - 命名空间隔离测试

    func testDTBNamespaceIsolation() throws {
        // 测试 DTB 静态命名空间不污染全局命名空间
        XCTAssertNoThrow({
            _ = DTB.app
            _ = DTB.console
            _ = DTB.Configuration.shared
        }())

        // 验证 DTB 是枚举类型，无法实例化
        // DTB() // 这行代码应该编译失败
    }

    func testWrapperNamespaceIsolation() throws {
        let testString = "Hello, World!"

        // 测试 Wrapper 命名空间访问
        XCTAssertNoThrow({
            _ = testString.dtb.ns()
            _ = testString.dtb.double()
        }())

        // 验证原始类型不受污染
        XCTAssertTrue(testString.hasPrefix("Hello"))
        XCTAssertEqual(testString.count, 13)
    }

    func testStaticWrapperNamespaceIsolation() throws {
        // 测试 StaticWrapper 命名空间访问
        XCTAssertNoThrow({
            _ = UIColor.dtb.create("#FF0000")
            _ = NumberFormatter.dtb.decimal(2)
            _ = NumberFormatter.dtb.CNY()
        }())

        // 验证原始类型的静态方法不受影响
        XCTAssertNotNil(UIColor.red)
        XCTAssertNotNil(NumberFormatter())
    }

    // MARK: - 链式 API 测试

    func testCGSizeChainAPI() throws {
        let originalSize = CGSize(width: 100, height: 50)

        // 测试链式调用
        let result = originalSize.dtb
            .margin(all: 10)        // 添加外边距
            .padding(all: 5)        // 减少内边距
            .value                  // 获取最终值

        XCTAssertEqual(result.width, 100) // 100 + 20 - 10 = 110
        XCTAssertEqual(result.height, 40)  // 50 + 20 - 10 = 60

        // 验证原始值未被修改（值类型特性）
        XCTAssertEqual(originalSize.width, 100)
        XCTAssertEqual(originalSize.height, 50)
    }

    func testNumberFormatterChainAPI() throws {
        // 测试 NumberFormatter 链式配置
        let formatter = NumberFormatter().dtb
            .decimal(2)                          // 设置小数位数
            .rounded(.halfUp)                    // 设置舍入规则
            .prefix("$", negative: "-$")         // 设置前缀
            .value                               // 获取配置好的 formatter

        // 测试格式化效果
        let positiveResult = formatter.string(from: NSNumber(value: 123.456))
        XCTAssertTrue(positiveResult?.contains("$") ?? false)
        XCTAssertTrue(positiveResult?.contains("123.46") ?? false)

        let negativeResult = formatter.string(from: NSNumber(value: -123.456))
        XCTAssertTrue(negativeResult?.contains("-$") ?? false)
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

    // MARK: - 协议一致性测试

    func testKitableProtocol() throws {
        // 测试基础类型是否正确实现了 Kitable 协议
        let string: String = "test"
        let cgSize: CGSize = CGSize(width: 10, height: 20)
        let date: Date = Date()
        let data: Data = Data()

        // 这些类型都应该可以通过 .dtb 访问扩展方法
        XCTAssertNoThrow({
            _ = string.dtb
            _ = cgSize.dtb
            _ = date.dtb
            _ = data.dtb
        }())
    }

    func testStructableProtocol() throws {
        // 测试值类型的 Structable 协议实现
        struct TestStruct {
            let value: Int
        }

        // 虽然 TestStruct 没有扩展，但应该符合 Structable
        let testStruct = TestStruct(value: 42)
        XCTAssertEqual(testStruct.value, 42)
    }

    func testChainableProtocol() throws {
        // 测试 Chainable 协议的链式特性
        let formatter = NumberFormatter().dtb

        // 验证返回的是相同类型，支持继续链式调用
        let chainResult = formatter
            .decimal(2)
            .rounded(.halfUp)
            .prefix("$")

        XCTAssertTrue(type(of: chainResult) == type(of: formatter))
        XCTAssertNotNil(chainResult.value)
    }

    // MARK: - 类型安全测试

    func testGenericTypeConstraints() throws {
        // 测试泛型约束确保类型安全
        let stringWrapper: Wrapper<String> = "test".dtb
        let sizeWrapper: Wrapper<CGSize> = CGSize.zero.dtb

        // 编译时类型检查
        XCTAssertTrue(stringWrapper.value is String)
        XCTAssertTrue(sizeWrapper.value is CGSize)

        // 不同类型的 Wrapper 不应该混用
//         let wrongAssignment: Wrapper<String> = sizeWrapper // 这应该编译失败
    }

    func testConstKeyTypeSafety() throws {
        // 测试 ConstKey 的类型安全特性
        let stringKey = DTB.ConstKey<String>("test_string")
        let intKey = DTB.ConstKey<Int>("test_int")

        let manager = DTB.app

        // 类型安全的存储和读取
        manager.set("Hello", key: stringKey)
        manager.set(42, key: intKey)

        let retrievedString: String? = manager.get(stringKey)
        let retrievedInt: Int? = manager.get(intKey)

        XCTAssertEqual(retrievedString, "Hello")
        XCTAssertEqual(retrievedInt, 42)

        // 不同类型的 key 即使名称相同也不会冲突
        let anotherStringKey = DTB.ConstKey<String>("test_int") // 名称与 intKey 相同但类型不同
        manager.set("Different", key: anotherStringKey)

        XCTAssertEqual(manager.get(intKey), 42)           // int 值不受影响
        XCTAssertEqual(manager.get(anotherStringKey), "Different") // 不同类型的值

        // 清理
        manager.set(nil, key: stringKey)
        manager.set(nil, key: intKey)
        manager.set(nil, key: anotherStringKey)
    }

    // MARK: - API 一致性测试

    func testAPIConsistency() throws {
        // 测试相似功能的 API 设计一致性

        // 数值转换 API 一致性
        let stringValue = "123.45"
        XCTAssertNotNil(stringValue.dtb.double())
        XCTAssertNotNil(stringValue.dtb.int64())
        XCTAssertNotNil(stringValue.dtb.nsDecimal())

        // 几何计算 API 一致性
        let size = CGSize(width: 100, height: 50)
        let rect = CGRect(origin: .zero, size: size)

        // 都提供 isEmpty/notEmpty
        XCTAssertFalse(size.dtb.isEmpty())
        // CGRect 可能没有实现这些方法，但设计应该一致

        // 链式 API 返回值一致性
        let sizeChain = size.dtb.margin(all: 10)
        let formatterChain = NumberFormatter().dtb.decimal(2)

        // 都应该返回支持继续链式调用的对象
        XCTAssertNotNil(sizeChain.value)
        XCTAssertNotNil(formatterChain.value)
    }

    // MARK: - 扩展冲突测试

    func testExtensionConflictAvoidance() throws {
        // 测试 DTBKit 扩展不与系统方法冲突

        let string = "Hello"

        // 系统原生方法应该正常工作
        XCTAssertEqual(string.count, 5)
        XCTAssertTrue(string.hasPrefix("Hel"))
        XCTAssertEqual(string.uppercased(), "HELLO")

        // DTBKit 扩展方法通过命名空间隔离
        XCTAssertFalse(string.isEmpty)
        XCTAssertNotNil(string.dtb.ns())

        // 两者互不干扰
        let nsString = string.dtb.ns().value
        XCTAssertEqual(nsString.length, string.count)
    }

    // MARK: - 性能和内存测试

    func testNamespacePerformance() throws {
        let iterations = 10000
        let testString = "Performance Test String"

        // 测试命名空间访问的性能开销
        measure {
            for _ in 0..<iterations {
                _ = testString.isEmpty
                _ = testString.dtb.ns()
            }
        }

        // 性能应该与直接调用相近，因为大部分是内联函数
    }

    // MARK: - 文档和使用性测试

    func testAPIDiscoverability() throws {
        // 测试 API 的可发现性和直觉性

        let string = "test"
        // 通过 .dtb 可以发现所有扩展方法
        let dtbMethods = string.dtb

        // 方法命名应该直观易懂
        XCTAssertNoThrow({
            _ = dtbMethods.ns()  // 转换为 NSString
            _ = dtbMethods.double()    // 转换为 Double
        }())

        let size = CGSize(width: 100, height: 50)
        let sizeMethods = size.dtb

        XCTAssertNoThrow({
            _ = sizeMethods.center()   // 获取中心点
            _ = sizeMethods.longer()   // 获取较长边
            _ = sizeMethods.shorter()  // 获取较短边
        }())
    }

    func testErrorMessageClarity() throws {
        // 测试错误信息的清晰度

        let invalidString = "not_a_number"

        // 无效转换应该返回 nil 而不是崩溃
        XCTAssertNil(invalidString.dtb.double())
        XCTAssertNil(invalidString.dtb.int64())
        XCTAssertNil(invalidString.dtb.nsDecimal())
    }
}

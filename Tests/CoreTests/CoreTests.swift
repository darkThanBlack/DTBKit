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

/// For code coverage.
#if canImport(DTBKit)
import DTBKit
#elseif canImport(DTBKit_Basic)
import DTBKit_Basic
#endif

/// DTBKit 命名空间和链式 API 设计测试
final class NamespaceAndChainTests: XCTestCase {
    
    ///
    class TestClass: Equatable {
        
        let name: String
        init(name: String) { self.name = name }
        
        static func == (lhs: TestClass, rhs: TestClass) -> Bool {
            return lhs.name == rhs.name
        }
    }
    
    func testNamespace() throws {
        // 测试 DTB 静态命名空间不污染全局命名空间
        XCTAssertNoThrow({
            _ = DTB.app
            _ = DTB.console
            _ = DTB.config
        }())

        // 验证 DTB 是枚举类型，无法实例化
        // DTB() // 这行代码应该编译失败
        
        let testString = "Hello, World!"

        // 测试 Wrapper 命名空间访问
        XCTAssertNoThrow({
            _ = testString.dtb.ns()
            _ = testString.dtb.double()
        }())

        // 验证原始类型不受污染
        XCTAssertTrue(testString.hasPrefix("Hello"))
        XCTAssertEqual(testString.count, 13)
        
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
    
    func testSimpleChain() throws {
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
        
        // 测试 Chainable 协议的链式特性
        let formatter = NumberFormatter().dtb

        // 验证返回的是相同类型，支持继续链式调用
        let chainResult = formatter
            .decimal(2)
            .rounded(.halfUp)
            .prefix("$")

        XCTAssertTrue(type(of: chainResult) == type(of: formatter))
        XCTAssertNotNil(chainResult.value)
        
        // 测试泛型约束确保类型安全
        let stringWrapper: Wrapper<String> = "test".dtb
        let sizeWrapper: Wrapper<CGSize> = CGSize.zero.dtb

        // 编译时类型检查
        XCTAssertTrue(stringWrapper.value is String)
        XCTAssertTrue(sizeWrapper.value is CGSize)

        // 不同类型的 Wrapper 不应该混用
//         let wrongAssignment: Wrapper<String> = sizeWrapper // 这应该编译失败
        
        let _ = {
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
        }()
        
        // 测试动态路径
        let _ = {
            let c = DyTestClass()
            c.text = "before"
            c.dtb.text("after")
            XCTAssertEqual(c.text, "after")
        }()
    }
    
    class DyTestClass: Kitable {
        
        var text: String? = nil
    }
    
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
    
    /// AppManager 内存管理测试
    func testAppManagerStorage() throws {
        
        let stringKey = DTB.ConstKey<String>("test_string")
        var testObject: TestClass? = TestClass(name: "weak_test")
        let weakKey = DTB.ConstKey<TestClass>("weak_key")
        let strongKey = DTB.ConstKey<TestClass>("strong_key")
        
        // 字符串存储
        DTB.app.set("test_value", key: stringKey)
        XCTAssertEqual(DTB.app.get(stringKey), "test_value")
        DTB.app.set(nil, key: stringKey)
        XCTAssertNil(DTB.app.get(stringKey))
        
        // 对象存储
        DTB.app.set(testObject, key: strongKey)
        XCTAssertEqual(DTB.app.get(strongKey), testObject)
        DTB.app.set(nil, key: strongKey)
        XCTAssertNil(DTB.app.get(strongKey))

        // 相同 rawValue 的 key 会造成覆盖
        let anotherStringKey = DTB.ConstKey<String>("test_string")
        DTB.app.set("another_value", key: anotherStringKey)
        XCTAssertEqual(DTB.app.get(stringKey), "another_value") // 被覆盖了
        
        // 弱引用存储
        DTB.app.setWeak(testObject, key: weakKey)
        XCTAssertNotNil(DTB.app.getWeak(weakKey))
        XCTAssertEqual(DTB.app.getWeak(weakKey)?.name, "weak_test")
        // 释放对象后，取值应该立即为空
        testObject = nil
        XCTAssertNil(DTB.app.getWeak(weakKey))
    }
    
    func testAppManagerStorageWithLock() throws {
        // 线程安全测试 - useLock: true
        let lockedKey = DTB.ConstKey<TestClass>("locked_key", useLock: true)
        let unlockedKey = DTB.ConstKey<TestClass>("unlocked_key", useLock: false)
        
        // 基本功能测试
        let testObj1 = TestClass(name: "locked_test")
        DTB.app.set(testObj1, key: lockedKey)
        XCTAssertEqual(DTB.app.get(lockedKey), testObj1)
        
        // 并发写入测试
        let concurrentWriteExpectation = expectation(description: "Concurrent write operations")
        concurrentWriteExpectation.expectedFulfillmentCount = 100
        
        let queue = DispatchQueue(label: "test.concurrent", attributes: .concurrent)
        
        for i in 0..<100 {
            queue.async {
                let obj = TestClass(name: "concurrent_\(i)")
                DTB.app.set(obj, key: lockedKey)
                concurrentWriteExpectation.fulfill()
            }
        }
        
        wait(for: [concurrentWriteExpectation], timeout: 5.0)
        
        // 验证最终状态是一致的（不会崩溃或数据损坏）
        let finalValue = DTB.app.get(lockedKey)
        XCTAssertNotNil(finalValue)
        XCTAssertTrue(finalValue!.name.hasPrefix("concurrent_"))
        
        // 并发读写测试
        let readWriteExpectation = expectation(description: "Concurrent read-write operations")
        readWriteExpectation.expectedFulfillmentCount = 200
        
        var readValues: [TestClass?] = []
        let readValuesLock = NSLock()
        
        // 100 个写操作
        for i in 0..<100 {
            queue.async {
                let obj = TestClass(name: "readwrite_\(i)")
                DTB.app.set(obj, key: lockedKey)
                readWriteExpectation.fulfill()
            }
        }
        
        // 100 个读操作
        for _ in 0..<100 {
            queue.async {
                let value = DTB.app.get(lockedKey)
                readValuesLock.lock()
                readValues.append(value)
                readValuesLock.unlock()
                readWriteExpectation.fulfill()
            }
        }
        
        wait(for: [readWriteExpectation], timeout: 5.0)
        
        // 验证读取的值都是有效的（没有读到中间状态或损坏的数据）
        XCTAssertEqual(readValues.count, 100)
        for value in readValues {
            if let val = value {
                XCTAssertTrue(val.name.hasPrefix("readwrite_") || val.name.hasPrefix("concurrent_"))
            }
        }
        
        // 弱引用并发测试
        let weakLockedKey = DTB.ConstKey<TestClass>("weak_locked_key", useLock: true)
        let weakConcurrentExpectation = expectation(description: "Weak reference concurrent operations")
        weakConcurrentExpectation.expectedFulfillmentCount = 50
        
        for i in 0..<50 {
            queue.async {
                autoreleasepool {
                    let obj = TestClass(name: "weak_concurrent_\(i)")
                    DTB.app.setWeak(obj, key: weakLockedKey)
                    
                    // 立即读取
                    let retrieved = DTB.app.getWeak(weakLockedKey)
                    XCTAssertTrue(retrieved == nil || retrieved?.name.hasPrefix("weak_concurrent_") == true)
                    
                    weakConcurrentExpectation.fulfill()
                }
            }
        }
        
        wait(for: [weakConcurrentExpectation], timeout: 5.0)
        
        // 验证弱引用最终状态
        XCTAssertNil(DTB.app.getWeak(weakLockedKey)) // 对象应该已经被释放
        
        // 性能对比测试（可选）
        let performanceKey = DTB.ConstKey<String>("performance_key", useLock: true)
        let nonLockKey = DTB.ConstKey<String>("non_lock_key", useLock: false)
        
        // 测量加锁版本的性能
        measure {
            for i in 0..<1000 {
                DTB.app.set("performance_test_\(i)", key: performanceKey)
                _ = DTB.app.get(performanceKey)
            }
        }

    }
    
    func testConsole() throws {
        DTB.console.log("same as Swift.print with func name")
        DTB.console.error("same as Swift.print, with more info")
    }
    
    func testProvider() throws {
        let key = DTB.ConstKey<String>()
        
        DTB.Providers.register("p", key: key)
        XCTAssertNotNil(DTB.Providers.get(key))
        DTB.Providers.unregister(key)
        XCTAssertNil(DTB.Providers.get(key))
    }
    
    // MARK: - 性能测试
    
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

}

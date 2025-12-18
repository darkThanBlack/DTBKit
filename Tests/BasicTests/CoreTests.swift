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

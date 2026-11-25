//
//  OptionalExtensionTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2026-11-24
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  OptionalCheckable / NumberCheckable 与 Optional 扩展的边界测试
//

import XCTest

/// For code coverage.
#if canImport(DTBKit)
@_exported import DTBKit
#elseif canImport(DTBKit_Basic)
@_exported import DTBKit_Basic
#endif

/// Optional 扩展边界测试
final class OptionalExtensionTests: XCTestCase {
    
    // MARK: - dtb_or
    
    func testOrString() {
        XCTAssertEqual(("" as String?).dtb_or(), "")                  // 空串 -> 默认空值
        XCTAssertEqual((nil as String?).dtb_or(), "")                 // nil -> 默认空值
        XCTAssertEqual(("a" as String?).dtb_or(), "a")                // 有效值保留
        XCTAssertEqual(("" as String?).dtb_or("兜底"), "兜底")         // 空串 -> def
    }
    
    func testOrNumber() {
        XCTAssertEqual((Double.nan as Double?).dtb_or(), 0)           // NaN -> 0
        XCTAssertEqual((Double.infinity as Double?).dtb_or(), 0)      // inf -> 0
        XCTAssertEqual((nil as Double?).dtb_or(), 0)                  // nil -> 0
        XCTAssertEqual((-3.0 as Double?).dtb_or(), -3.0)              // 有效负数保留
        XCTAssertEqual((0.0 as Double?).dtb_or(), 0)                  // 0 是有效值
    }
    
    // MARK: - validity
    
    func testIsInvalid() {
        XCTAssertTrue((nil as String?).dtb_isInvalid())
        XCTAssertTrue(("" as String?).dtb_isInvalid())
        XCTAssertFalse(("a" as String?).dtb_isInvalid())
        XCTAssertFalse((0 as Int?).dtb_isInvalid())                   // 整数没有无效态
        XCTAssertTrue((Double.nan as Double?).dtb_isInvalid())        // 浮点：非有限不可用
        XCTAssertFalse(([] as [Int]?).dtb_isValid())                  // 空集合不可用
        XCTAssertTrue(([1] as [Int]?).dtb_isValid())
    }
    
    // MARK: - number
    
    func testIsInvalidOrZero() {
        XCTAssertTrue((0.0 as Double?).dtb_isInvalidOrZero())
        XCTAssertTrue((nil as Double?).dtb_isInvalidOrZero())
        XCTAssertFalse((2.5 as Double?).dtb_isInvalidOrZero())
    }
    
    func testSign() {
        XCTAssertTrue((2.5 as Double?).dtb_isPositive())
        XCTAssertFalse((0.0 as Double?).dtb_isPositive())
        XCTAssertFalse((Double.nan as Double?).dtb_isPositive())
        XCTAssertTrue((-1.0 as Double?).dtb_isNegative())
        XCTAssertFalse((1.0 as Double?).dtb_isNegative())
    }
    
    // MARK: - 与 DTB.any 组合
    
    func testChainWithAnyConvert() {
        let dict: [String: Any] = ["width": "12.5", "count": 7]
        XCTAssertEqual(DTB.any.double(dict["width"]).dtb_or(), 12.5)
        XCTAssertEqual(DTB.any.int(dict["count"]).dtb_or(), 7)
    }
}

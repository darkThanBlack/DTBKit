//
//  OptionalCheckerTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2026-11-24
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  OptionalCheckable / NumberCheckable 与 DTB.check 的边界测试
//

import XCTest

/// For code coverage.
#if canImport(DTBKit)
@_exported import DTBKit
#elseif canImport(DTBKit_Basic)
@_exported import DTBKit_Basic
#endif

/// DTB.check 边界测试
final class OptionalCheckerTests: XCTestCase {
    
    // MARK: - or
    
    func testOrString() {
        XCTAssertEqual(DTB.check.or(""), "")                 // 空串 -> 默认空值
        XCTAssertEqual(DTB.check.or(nil as String?), "")     // nil -> 默认空值
        XCTAssertEqual(DTB.check.or("a"), "a")               // 有效值保留
        XCTAssertEqual(DTB.check.or("", def: "兜底"), "兜底") // 空串 -> def
    }
    
    func testOrNumber() {
        XCTAssertEqual(DTB.check.or(Double.nan), 0)          // NaN -> 0
        XCTAssertEqual(DTB.check.or(Double.infinity), 0)     // inf -> 0
        XCTAssertEqual(DTB.check.or(nil as Double?), 0)      // nil -> 0
        XCTAssertEqual(DTB.check.or(-3.0), -3.0)             // 有效负数保留
        XCTAssertEqual(DTB.check.or(0), 0)                   // 0 是有效值
    }
    
    // MARK: - validity
    
    func testIsInvalid() {
        XCTAssertTrue(DTB.check.isInvalid(nil as String?))
        XCTAssertTrue(DTB.check.isInvalid(""))
        XCTAssertFalse(DTB.check.isInvalid("a"))
        XCTAssertFalse(DTB.check.isInvalid(0))               // 整数没有无效态
        XCTAssertTrue(DTB.check.isInvalid(Double.nan))       // 浮点：非有限不可用
        XCTAssertFalse(DTB.check.isValid([]))                // 空集合不可用
        XCTAssertTrue(DTB.check.isValid([1]))
    }
    
    // MARK: - number
    
    func testIsInvalidOrZero() {
        XCTAssertTrue(DTB.check.isInvalidOrZero(0.0))
        XCTAssertTrue(DTB.check.isInvalidOrZero(nil as Double?))
        XCTAssertFalse(DTB.check.isInvalidOrZero(2.5))
    }
    
    func testSign() {
        XCTAssertTrue(DTB.check.isPositive(2.5))
        XCTAssertFalse(DTB.check.isPositive(0))
        XCTAssertFalse(DTB.check.isPositive(Double.nan))
        XCTAssertTrue(DTB.check.isNegative(-1))
        XCTAssertFalse(DTB.check.isNegative(1))
    }
}

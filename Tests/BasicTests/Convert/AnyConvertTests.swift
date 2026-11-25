//
//  AnyConvertTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2026-11-25
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  AnyConvert 的输入形态与边界测试
//

import XCTest

/// For code coverage.
#if canImport(DTBKit)
@_exported import DTBKit
#elseif canImport(DTBKit_Basic)
@_exported import DTBKit_Basic
#endif

/// DTB.any 边界测试
final class AnyConvertTests: XCTestCase {
    
    // MARK: - int64
    
    func testInt64FromNumbers() {
        XCTAssertEqual(DTB.any.int64(42), 42)
        XCTAssertEqual(DTB.any.int64(Int8(3)), 3)
        XCTAssertEqual(DTB.any.int64(NSNumber(value: 42)), 42)
        XCTAssertEqual(DTB.any.int64("42"), 42)
    }
    
    func testInt64TruncatesFloatingPoint() {
        XCTAssertEqual(DTB.any.int64(42.9), 42)
        XCTAssertEqual(DTB.any.int64(-42.9), -42)
        XCTAssertEqual(DTB.any.int64(Float(1.5)), 1)
    }
    
    func testInt64RejectsInvalid() {
        XCTAssertNil(DTB.any.int64(Double.nan))          // 不再 fatalError
        XCTAssertNil(DTB.any.int64(Double.infinity))
        XCTAssertNil(DTB.any.int64(-Double.infinity))
        XCTAssertNil(DTB.any.int64(Float.nan))
        XCTAssertNil(DTB.any.int64(1e300))               // 越界，不再 fatalError
        XCTAssertNil(DTB.any.int64("abc"))
        XCTAssertNil(DTB.any.int64(NSNull()))
        XCTAssertNil(DTB.any.int64(NSNumber(value: 42.5))) // 非整数不截断
    }
    
    // MARK: - double / cgFloat
    
    func testDouble() {
        XCTAssertEqual(DTB.any.double(42), 42)
        XCTAssertEqual(DTB.any.double(1.5), 1.5)
        XCTAssertEqual(DTB.any.double("12.5"), 12.5)
        XCTAssertEqual(DTB.any.double(NSNumber(value: 42.5)), 42.5)
        XCTAssertNil(DTB.any.double("abc"))
        XCTAssertNil(DTB.any.double(NSNull()))
    }
    
    func testDoubleRejectsNonFinite() {
        XCTAssertNil(DTB.any.double(Double.nan))
        XCTAssertNil(DTB.any.double(Double.infinity))
        XCTAssertNil(DTB.any.double(-Double.infinity))
        XCTAssertNil(DTB.any.double("inf"))
        XCTAssertNil(DTB.any.double("nan"))
        XCTAssertNil(DTB.any.double(NSNumber(value: Double.nan)))
    }
    
    func testCGFloat() {
        XCTAssertEqual(DTB.any.cgFloat(1.5), 1.5)
        XCTAssertEqual(DTB.any.cgFloat("2.5"), 2.5)
        XCTAssertNil(DTB.any.cgFloat(NSNull()))
        XCTAssertNil(DTB.any.cgFloat(CGFloat.nan))
        XCTAssertNil(DTB.any.cgFloat("nan"))
    }
}

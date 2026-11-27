//
//  NumberCheckableCoreTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2026-11-26
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//

import XCTest

#if canImport(DTBKit)
import DTBKit
#elseif canImport(DTBKit_Core)
import DTBKit_Core
#endif

final class NumberCheckableCoreTests: XCTestCase {

    func testInt() {
        XCTAssertEqual(Int.dtb_defaultValue(), 0)
        XCTAssertFalse(Int.min.dtb_isInvalid())
        XCTAssertTrue(Int(0).dtb_isZero())
        XCTAssertFalse(Int(1).dtb_isZero())
        XCTAssertTrue(Int(1).dtb_isPositive())
        XCTAssertFalse(Int(1).dtb_isNegative())
        XCTAssertTrue(Int(-1).dtb_isNegative())
        XCTAssertFalse(Int(-1).dtb_isPositive())
    }

    func testInt8() {
        XCTAssertEqual(Int8.dtb_defaultValue(), 0)
        XCTAssertFalse(Int8.min.dtb_isInvalid())
        XCTAssertTrue(Int8(0).dtb_isZero())
        XCTAssertTrue(Int8(1).dtb_isPositive())
        XCTAssertTrue(Int8(-1).dtb_isNegative())
    }

    func testInt16() {
        XCTAssertEqual(Int16.dtb_defaultValue(), 0)
        XCTAssertFalse(Int16.min.dtb_isInvalid())
        XCTAssertTrue(Int16(0).dtb_isZero())
        XCTAssertTrue(Int16(1).dtb_isPositive())
        XCTAssertTrue(Int16(-1).dtb_isNegative())
    }

    func testInt32() {
        XCTAssertEqual(Int32.dtb_defaultValue(), 0)
        XCTAssertFalse(Int32.min.dtb_isInvalid())
        XCTAssertTrue(Int32(0).dtb_isZero())
        XCTAssertTrue(Int32(1).dtb_isPositive())
        XCTAssertTrue(Int32(-1).dtb_isNegative())
    }

    func testInt64() {
        XCTAssertEqual(Int64.dtb_defaultValue(), 0)
        XCTAssertFalse(Int64.min.dtb_isInvalid())
        XCTAssertTrue(Int64(0).dtb_isZero())
        XCTAssertTrue(Int64(1).dtb_isPositive())
        XCTAssertTrue(Int64(-1).dtb_isNegative())
    }

    func testFloat() {
        XCTAssertEqual(Float.dtb_defaultValue(), 0)
        XCTAssertFalse(Float(1.5).dtb_isInvalid())
        XCTAssertTrue(Float.nan.dtb_isInvalid())
        XCTAssertTrue(Float.infinity.dtb_isInvalid())
        XCTAssertTrue(Float(0).dtb_isZero())
        XCTAssertTrue(Float(1.5).dtb_isPositive())
        XCTAssertTrue(Float(-1.5).dtb_isNegative())
    }

    func testDouble() {
        XCTAssertEqual(Double.dtb_defaultValue(), 0)
        XCTAssertFalse(Double(1.5).dtb_isInvalid())
        XCTAssertTrue(Double.nan.dtb_isInvalid())
        XCTAssertTrue(Double.infinity.dtb_isInvalid())
        XCTAssertTrue(Double(0).dtb_isZero())
        XCTAssertTrue(Double(1.5).dtb_isPositive())
        XCTAssertTrue(Double(-1.5).dtb_isNegative())
    }

    func testOptionalNumber() {
        XCTAssertTrue((0 as Int?).dtb_isInvalidOrZero())
        XCTAssertTrue((nil as Int?).dtb_isInvalidOrZero())
        XCTAssertFalse((2 as Int?).dtb_isInvalidOrZero())
        XCTAssertTrue((2 as Int?).dtb_isPositive())
        XCTAssertFalse((0 as Int?).dtb_isPositive())
        XCTAssertTrue((-2 as Int?).dtb_isNegative())
        XCTAssertFalse((0 as Int?).dtb_isNegative())
        XCTAssertFalse((nil as Int?).dtb_isPositive())
        XCTAssertFalse((nil as Int?).dtb_isNegative())
        XCTAssertEqual((nil as Int?).dtb_or(), 0)
        XCTAssertEqual((nil as Float?).dtb_or(), 0)
    }
}

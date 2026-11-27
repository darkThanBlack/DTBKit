//
//  OptionalCheckableCoreTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2026-11-26
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//

import XCTest
import CoreGraphics

#if canImport(DTBKit)
import DTBKit
#elseif canImport(DTBKit_Core)
import DTBKit_Core
#endif

final class OptionalCheckableCoreTests: XCTestCase {

    func testString() {
        XCTAssertTrue("".dtb_isInvalid())
        XCTAssertFalse("a".dtb_isInvalid())
        XCTAssertTrue("a".dtb_isValid())
        XCTAssertEqual(String.dtb_defaultValue(), "")
    }

    func testDictionary() {
        XCTAssertTrue([String: Int]().dtb_isInvalid())
        XCTAssertFalse(["a": 1].dtb_isInvalid())
        XCTAssertTrue([String: Int]().dtb_isValid() == false)
        XCTAssertEqual(Dictionary<String, Int>.dtb_defaultValue().count, 0)
    }

    func testArray() {
        XCTAssertTrue([Int]().dtb_isInvalid())
        XCTAssertFalse([1].dtb_isInvalid())
        XCTAssertEqual(Array<Int>.dtb_defaultValue(), [])
    }

    func testSet() {
        XCTAssertTrue(Set<Int>().dtb_isInvalid())
        XCTAssertFalse(Set([1]).dtb_isInvalid())
        XCTAssertEqual(Set<Int>.dtb_defaultValue(), [])
    }

    func testCGSize() {
        XCTAssertEqual(CGSize.dtb_defaultValue(), .zero)
        XCTAssertTrue(CGSize.zero.dtb_isInvalid())
        XCTAssertTrue(CGSize(width: 10, height: 0).dtb_isInvalid())
        XCTAssertTrue(CGSize(width: 0, height: 10).dtb_isInvalid())
        XCTAssertTrue(CGSize(width: -1, height: 10).dtb_isInvalid())
        XCTAssertFalse(CGSize(width: 10, height: 10).dtb_isValid() == false)
    }

    func testCGRect() {
        XCTAssertEqual(CGRect.dtb_defaultValue(), .zero)
        XCTAssertTrue(CGRect.zero.dtb_isInvalid())
        XCTAssertTrue(CGRect(x: 0, y: 0, width: 10, height: 0).dtb_isInvalid())
        XCTAssertFalse(CGRect(x: 0, y: 0, width: 10, height: 10).dtb_isInvalid())
    }

    func testNSRange() {
        XCTAssertEqual(NSRange.dtb_defaultValue(), NSRange(location: 0, length: 0))
        XCTAssertTrue(NSRange(location: NSNotFound, length: 0).dtb_isInvalid())
        XCTAssertTrue(NSRange(location: 0, length: -1).dtb_isInvalid())
        XCTAssertFalse(NSRange(location: 0, length: 0).dtb_isInvalid())
        XCTAssertFalse(NSRange(location: 3, length: 2).dtb_isInvalid())
    }

    func testOptionalGeometry() {
        XCTAssertTrue((nil as CGSize?).dtb_isInvalid())
        XCTAssertFalse((CGSize(width: 1, height: 1) as CGSize?).dtb_isValid() == false)
        XCTAssertTrue((nil as CGRect?).dtb_isInvalid())
        XCTAssertTrue((nil as NSRange?).dtb_isInvalid())
        XCTAssertEqual((nil as CGSize?).dtb_or(), .zero)
        XCTAssertEqual((NSRange(location: NSNotFound, length: 0) as NSRange?).dtb_or(), NSRange(location: 0, length: 0))
    }
}

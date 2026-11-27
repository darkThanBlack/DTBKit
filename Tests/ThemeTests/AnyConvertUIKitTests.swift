//
//  AnyConvertUIKitTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2026-11-27
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//

import XCTest
import UIKit

#if canImport(DTBKit)
import DTBKit
#elseif canImport(DTBKit_Theme)
import DTBKit_Theme
#endif

final class AnyConvertUIKitTests: XCTestCase {

    func testUIEdgeInsets() {
        XCTAssertEqual(
            DTB.any.uiEdgeInsets(["top": 1, "left": 2, "bottom": 3, "right": 4]),
            UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        )
        XCTAssertEqual(DTB.any.uiEdgeInsets(["top": "1.5"]), UIEdgeInsets(top: 1.5, left: 0, bottom: 0, right: 0))
        XCTAssertNil(DTB.any.uiEdgeInsets(nil))
        XCTAssertNil(DTB.any.uiEdgeInsets(1))
    }

    func testCGSize() {
        XCTAssertEqual(DTB.any.cgSize(["width": 10, "height": 20]), CGSize(width: 10, height: 20))
        XCTAssertEqual(DTB.any.cgSize(["width": "10.5"]), CGSize(width: 10.5, height: 0))
        XCTAssertNil(DTB.any.cgSize(nil))
        XCTAssertNil(DTB.any.cgSize("10x20"))
    }

    func testCGVector() {
        XCTAssertEqual(DTB.any.cgVector(["dx": 1, "dy": 2]), CGVector(dx: 1, dy: 2))
        XCTAssertEqual(DTB.any.cgVector(["dx": "1.5"]), CGVector(dx: 1.5, dy: 0))
        XCTAssertNil(DTB.any.cgVector(nil))
        XCTAssertNil(DTB.any.cgVector(1))
    }

    func testRectCornerFromValue() {
        XCTAssertEqual(DTB.any.rectCorner(UIRectCorner.allCorners), .allCorners)
        XCTAssertEqual(DTB.any.rectCorner(UIRectCorner.topLeft), .topLeft)
    }

    func testRectCornerFromNames() {
        XCTAssertEqual(DTB.any.rectCorner("all"), .allCorners)
        XCTAssertEqual(DTB.any.rectCorner("allCorners"), .allCorners)
        XCTAssertEqual(DTB.any.rectCorner("topLeft"), .topLeft)
        XCTAssertEqual(DTB.any.rectCorner("BOTTOMRIGHT"), .bottomRight)
        XCTAssertEqual(DTB.any.rectCorner(["topLeft", "topRight"])?.rawValue, 3)
    }

    func testRectCornerFromNumbers() {
        XCTAssertEqual(DTB.any.rectCorner(1), .topLeft)
        XCTAssertEqual(DTB.any.rectCorner(NSNumber(value: 2)), .topRight)
        XCTAssertEqual(DTB.any.rectCorner(15)?.rawValue, UIRectCorner(rawValue: 15).rawValue)
        XCTAssertEqual(DTB.any.rectCorner([1, 2])?.rawValue, 3)
        XCTAssertEqual(DTB.any.rectCorner([NSNumber(value: 1), "topRight"])?.rawValue, 3)
        XCTAssertEqual(DTB.any.rectCorner("1"), .topLeft)
    }

    func testRectCornerEmptyIsNil() {
        XCTAssertNil(DTB.any.rectCorner([] as [Any]))
        XCTAssertNil(DTB.any.rectCorner(0))
        XCTAssertNil(DTB.any.rectCorner("0"))
        XCTAssertNil(DTB.any.rectCorner(UIRectCorner()))
    }

    func testRectCornerInvalid() {
        XCTAssertNil(DTB.any.rectCorner(nil))
        XCTAssertNil(DTB.any.rectCorner("bogus"))
        XCTAssertNil(DTB.any.rectCorner(["bogus"]))
        XCTAssertNil(DTB.any.rectCorner(-1))
        XCTAssertNil(DTB.any.rectCorner(NSNull()))
    }

    func testFillRule() {
        XCTAssertEqual(DTB.any.fillRule("nonZero"), .nonZero)
        XCTAssertEqual(DTB.any.fillRule("NONZERO"), .nonZero)
        XCTAssertEqual(DTB.any.fillRule("evenOdd"), .evenOdd)
        XCTAssertNil(DTB.any.fillRule("bogus"))
        XCTAssertNil(DTB.any.fillRule(1))
        XCTAssertNil(DTB.any.fillRule(nil))
    }

    func testLineCap() {
        XCTAssertEqual(DTB.any.lineCap("butt"), .butt)
        XCTAssertEqual(DTB.any.lineCap("round"), .round)
        XCTAssertEqual(DTB.any.lineCap("SQUARE"), .square)
        XCTAssertNil(DTB.any.lineCap("bogus"))
        XCTAssertNil(DTB.any.lineCap(nil))
    }

    func testLineJoin() {
        XCTAssertEqual(DTB.any.lineJoin("miter"), .miter)
        XCTAssertEqual(DTB.any.lineJoin("round"), .round)
        XCTAssertEqual(DTB.any.lineJoin("bevel"), .bevel)
        XCTAssertNil(DTB.any.lineJoin("bogus"))
        XCTAssertNil(DTB.any.lineJoin(nil))
    }

    func testGradientLayerType() {
        XCTAssertEqual(DTB.any.gradientLayerType("axial"), .axial)
        XCTAssertEqual(DTB.any.gradientLayerType("RADIAL"), .radial)
        XCTAssertEqual(DTB.any.gradientLayerType("conic"), .conic)
        XCTAssertNil(DTB.any.gradientLayerType("bogus"))
        XCTAssertNil(DTB.any.gradientLayerType(nil))
    }

    func testTextAlignment() {
        XCTAssertEqual(DTB.any.textAlignment(NSTextAlignment.center), .center)
        XCTAssertEqual(DTB.any.textAlignment("left"), .left)
        XCTAssertEqual(DTB.any.textAlignment("CENTER"), .center)
        XCTAssertEqual(DTB.any.textAlignment("right"), .right)
        XCTAssertEqual(DTB.any.textAlignment("justified"), .justified)
        XCTAssertEqual(DTB.any.textAlignment("natural"), .natural)
        XCTAssertNil(DTB.any.textAlignment("bogus"))
        XCTAssertNil(DTB.any.textAlignment(nil))
    }
}

//
//  StylesParseTests.swift
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
@testable import DTBKit
#elseif canImport(DTBKit_Theme)
@testable import DTBKit_Theme
#endif

final class StylesParseTests: XCTestCase {

    private final class FakeColorProvider: DTB.Providers.ColorProvider {

        func create(_ param: Any?) -> UIColor? {
            switch param as? String {
            case "bg": return .red
            case "fill": return .blue
            default: return nil
            }
        }
    }

    private func registerColorProvider() {
        DTB.Providers.register(FakeColorProvider(), key: DTB.Providers.colorKey)
    }

    override func tearDown() {
        DTB.Providers.unregister(DTB.Providers.colorKey)
        super.tearDown()
    }

    func testParseShapeStyle() {
        let style = DTB.ShapeStyle.style([
            "corners": ["topLeft", "topRight"],
            "radius": 12,
            "lineWidth": 1.5,
            "strokeStart": "0.2",
            "fillRule": "evenOdd",
            "lineCap": "square",
            "lineJoin": "bevel",
            "lineDashPattern": [1, 2]
        ])
        XCTAssertEqual(style?.corners, [.topLeft, .topRight])
        XCTAssertEqual(style?.radius, .fixed(12))
        XCTAssertEqual(style?.lineWidth, 1.5)
        XCTAssertEqual(style?.strokeStart, 0.2)
        XCTAssertEqual(style?.fillRule, .evenOdd)
        XCTAssertEqual(style?.lineCap, .square)
        XCTAssertEqual(style?.lineJoin, .bevel)
        XCTAssertEqual(style?.lineDashPattern, [1, 2])
    }

    func testParseCornerRadius() {
        XCTAssertEqual(DTB.CornerRadiusStyle.parse(8), .fixed(8))
        XCTAssertEqual(DTB.CornerRadiusStyle.parse(["fixed": 8]), .fixed(8))
        XCTAssertEqual(DTB.CornerRadiusStyle.parse(["widthPercent": 0.5]), .widthPercent(0.5))
        XCTAssertEqual(DTB.CornerRadiusStyle.parse(["heightPercent": "0.25"]), .heightPercent(0.25))
        XCTAssertNil(DTB.CornerRadiusStyle.parse(nil))
        XCTAssertNil(DTB.CornerRadiusStyle.parse(["bogus": 1]))
    }

    func testParseGradientStyle() {
        registerColorProvider()
        let style = DTB.GradientStyle.style([
            "colors": ["bg", "fill"],
            "locations": [0, 1],
            "startPoint": ["x": 0, "y": 0.5],
            "endPoint": ["x": 1, "y": 0.5],
            "type": "radial"
        ])
        XCTAssertEqual(style?.colors?.count, 2)
        XCTAssertEqual(style?.locations, [0, 1])
        XCTAssertEqual(style?.startPoint, CGPoint(x: 0, y: 0.5))
        XCTAssertEqual(style?.endPoint, CGPoint(x: 1, y: 0.5))
        XCTAssertEqual(style?.type, .radial)
    }

    func testParseContainerNestedShapeAndFallback() {
        registerColorProvider()
        let style = DTB.ContainerStyle.style([
            "backgroundColor": "bg",
            "margin": ["top": 8, "left": 16, "bottom": 8, "right": 16],
            "shape": ["radius": 12],
            "gradient": ["type": "axial"]
        ])
        XCTAssertEqual(style?.margin, UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        XCTAssertEqual(style?.shape?.radius, .fixed(12))
        XCTAssertEqual(style?.shape?.fillColor, .red)
        XCTAssertNotNil(style?.gradient?.shapeMask)
    }

    func testParseButtonStyle() {
        let style = DTB.ButtonStyle.style([
            "title": "ok",
            "padding": ["top": 12, "left": 50, "bottom": 12, "right": 50],
            "imageSize": ["width": 16, "height": 16],
            "imageDirection": "left",
            "imageOffset": ["dx": 2, "dy": 3]
        ])
        XCTAssertEqual(style?.title, "ok")
        XCTAssertEqual(style?.contentEdgeInsets, UIEdgeInsets(top: 12, left: 50, bottom: 12, right: 50))
        XCTAssertEqual(style?.imageSize, CGSize(width: 16, height: 16))
        XCTAssertEqual(style?.imageDirection, .left)
        XCTAssertEqual(style?.imageOffset, CGVector(dx: 2, dy: 3))
        XCTAssertNil(style?.font)
        XCTAssertNil(style?.textColor)
        XCTAssertNil(style?.tintColor)
    }

    func testParseLabelStyle() {
        let style = DTB.LabelStyle.style([
            "contentEdgeInsets": ["top": 6, "left": 10, "bottom": 6, "right": 10],
            "numberOfLines": 0,
            "textAlignment": "center"
        ])
        XCTAssertEqual(style?.contentEdgeInsets, UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        XCTAssertEqual(style?.numberOfLines, 0)
        XCTAssertEqual(style?.textAlignment, .center)
        XCTAssertNil(style?.font)
        XCTAssertNil(style?.shape)
    }

    func testParseTextStyle() {
        let style = DTB.TextStyle.style(["textColor": "bg"])
        XCTAssertNotNil(style)
    }

    func testFontManagerParsesDict() {
        let font = DTB.FontManager.shared.create(["size": 15, "weight": "medium"])
        XCTAssertNotNil(font)
        XCTAssertEqual(font?.pointSize, 15)
    }
}

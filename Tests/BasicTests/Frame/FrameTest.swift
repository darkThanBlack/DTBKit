//
//  FrameTest.swift
//  DTBKit_Basic_Tests
//
//  Created by moonShadow on 2025/12/31
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import XCTest

final class FrameTest: XCTestCase {

    // MARK: - CGSize Extensions Tests

    func testCGSizeBasicProperties() throws {
        let validSize = CGSize(width: 100, height: 50)
        let invalidSize = CGSize(width: -10, height: 0)

        // 基础属性测试
        XCTAssertEqual(invalidSize.dtb.safe().value, CGSize.zero)
        XCTAssertFalse(validSize.dtb.isEmpty())
        XCTAssertTrue(validSize.dtb.notEmpty())
        XCTAssertFalse(invalidSize.dtb.notEmpty())

        // 几何计算测试
        XCTAssertEqual(validSize.dtb.center(), CGPoint(x: 50, y: 25))
        XCTAssertEqual(validSize.dtb.longer(), 100)
        XCTAssertEqual(validSize.dtb.shorter(), 50)
        XCTAssertEqual(validSize.dtb.area(), 5000)

        // 负数处理
        XCTAssertEqual(invalidSize.dtb.center(), CGPoint.zero)
        XCTAssertEqual(invalidSize.dtb.longer(), 0)
        XCTAssertEqual(invalidSize.dtb.shorter(), 0)
        XCTAssertEqual(invalidSize.dtb.area(), 0)
    }

    func testCGSizeSquareOperations() throws {
        let validSize = CGSize(width: 100, height: 50)
        let squareSize = CGSize(width: 50, height: 50)
        let invalidSize = CGSize(width: -10, height: 0)

        // 正方形判断
        XCTAssertFalse(validSize.dtb.isSquare())
        XCTAssertTrue(squareSize.dtb.isSquare())
        XCTAssertFalse(invalidSize.dtb.isSquare())

        // 内接正方形
        XCTAssertEqual(validSize.dtb.inSquare().value, CGSize(width: 50, height: 50))
        XCTAssertEqual(invalidSize.dtb.inSquare().value, CGSize.zero)

        // 外接正方形
        XCTAssertEqual(validSize.dtb.outSquare().value, CGSize(width: 100, height: 100))
        XCTAssertEqual(invalidSize.dtb.outSquare().value, CGSize.zero)
    }

    func testCGSizeLayoutOperations() throws {
        let validSize = CGSize(width: 100, height: 50)
        let invalidSize = CGSize(width: -10, height: 0)

        // 边距操作
        XCTAssertEqual(validSize.dtb.margin(all: 10).value, CGSize(width: 120, height: 70))
        XCTAssertEqual(validSize.dtb.margin(dx: 5, dy: 15).value, CGSize(width: 110, height: 80))

        // 内边距操作
        XCTAssertEqual(validSize.dtb.padding(all: 5).value, CGSize(width: 90, height: 40))
        XCTAssertEqual(validSize.dtb.padding(dx: 10, dy: 5).value, CGSize(width: 80, height: 40))

        // 负数处理
        XCTAssertEqual(invalidSize.dtb.margin(all: 10).value, CGSize(width: 20, height: 20))
        XCTAssertEqual(invalidSize.dtb.padding(all: 5).value, CGSize.zero)
    }

    func testCGSizeAspectOperations() throws {
        let sourceSize = CGSize(width: 100, height: 50)
        let targetSize = CGSize(width: 200, height: 200)

        // aspectFit - 保持宽高比，完全显示
        let fitResult = sourceSize.dtb.aspectFit(to: targetSize).value
        XCTAssertEqual(fitResult, CGSize(width: 200, height: 100)) // 按宽度缩放

        // aspectFill - 保持宽高比，完全填充
        let fillResult = sourceSize.dtb.aspectFill(to: targetSize).value
        XCTAssertEqual(fillResult, CGSize(width: 400, height: 200)) // 按高度缩放

        // 1:1 比例
        let squareSize = CGSize(width: 100, height: 100)
        XCTAssertEqual(squareSize.dtb.aspectFit(to: targetSize).value, targetSize)
        XCTAssertEqual(squareSize.dtb.aspectFill(to: targetSize).value, targetSize)

        // 负数处理
        let negativeSize = CGSize(width: -100, height: -50)
        XCTAssertEqual(negativeSize.dtb.aspectFit(to: targetSize).value, targetSize)
        XCTAssertEqual(negativeSize.dtb.aspectFill(to: targetSize).value, targetSize)
        XCTAssertEqual(sourceSize.dtb.aspectFit(to: negativeSize).value, CGSize.zero)
        XCTAssertEqual(sourceSize.dtb.aspectFill(to: negativeSize).value, CGSize.zero)
    }
    
}

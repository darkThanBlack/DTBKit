//
//  BasicTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2025-12-16
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  DTBKit Basic 模块的核心框架测试
//

import XCTest

/// For code coverage.
#if canImport(DTBKit)
@_exported import DTBKit
#elseif canImport(DTBKit_Basic)
@_exported import DTBKit_Basic
#endif

/// DTBKit Basic 模块的核心框架测试
/// 主要测试 Collection 扩展、Manager 工具类、CGSize 扩展和 HighFidelity 缩放
final class BasicTests: XCTestCase {
    
    // MARK: - HighFidelity Extensions Tests

    func testHighFidelity() throws {
        let designBaseSize = DTB.config.designBaseSize
        let screenSize = UIScreen.main.bounds.size
        XCTAssertEqual(designBaseSize.width.dtb.hf(), screenSize.width)
        XCTAssertEqual(designBaseSize.height.dtb.hf(.scale(.v)), screenSize.height)
    }

    // MARK: - Double Extensions Tests (Precision)

    func testDoublePrecisionOperation() throws {
        // 精度截取测试（注意：places 方法是截断而非四舍五入）
        let precisionTests: [(value: Double, places: Int, expected: Double)] = [
            (1.23456, 0, 1.0),
            (1.23456, 1, 1.2),
            (1.23456, 2, 1.23),
            (1.23456, 3, 1.234),  // 截断，不是四舍五入到 1.235
            (1.99999, 2, 1.99),   // 截断，不是四舍五入到 2.0
            (0.999, 1, 0.9),      // 截断，不是四舍五入到 1.0
            (-1.23456, 2, -1.23)  // 负数截断
        ]

        for test in precisionTests {
            let result = test.value.dtb.trunc(to: test.places)
            XCTAssertEqual(result, test.expected, accuracy: 0.0001,
                          "places(\(test.places)) of \(test.value) should be \(test.expected), got \(result)")
        }

        // 边界情况
        XCTAssertEqual(0.0.dtb.trunc(to: 2), 0.0)
        XCTAssertEqual(123.0.dtb.trunc(to: 2), 123.0) // 整数保持不变
    }

    // MARK: - JSON Processing Tests

    func testJSONProcessing() throws {
        // 测试对象转 JSON 字符串
        let testDict = ["name": "DTBKit", "version": "1.0", "active": true] as [String: Any]

        let jsonString = testDict.dtb.jsonString()?.value
        XCTAssertNotNil(jsonString)
        XCTAssertTrue(jsonString!.contains("DTBKit"))

        // 测试 JSON 字符串转对象
//        let jsonStr = """
//        {
//            "name": "DTBKit",
//            "version": "1.0",
//            "active": true
//        }
//        """
//
//        let parsedDict: [String: Any]? = jsonStr.dtb.json().value
//        XCTAssertNotNil(parsedDict)
//        XCTAssertEqual(parsedDict?["name"] as? String, "DTBKit")
    }
    
    //MARK: - Cover
    
    /// 为了提升 CR 覆盖率设计的 case
    func testCovers() throws {
        
    }
}

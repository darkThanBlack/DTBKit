//
//  CollectionTest.swift
//  DTBKit_Basic_Tests
//
//  Created by moonShadow on 2025/12/31
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import XCTest

final class CollectionTest: XCTestCase {

    // MARK: - Collection Extensions Tests

    func testCollectionSafeAccess() throws {
        let intArray = [1, 2, 3, 4, 5]

        // 有效索引
        XCTAssertEqual(intArray.dtb[0], 1)
        XCTAssertEqual(intArray.dtb[2], 3)
        XCTAssertEqual(intArray.dtb[4], 5)

        // 无效索引
        XCTAssertNil(intArray.dtb[-1])
        XCTAssertNil(intArray.dtb[5])
        XCTAssertNil(intArray.dtb[100])

        // nil 索引
        XCTAssertNil(intArray.dtb[nil])

        // 空数组
        let emptyArray: [Int] = []
        XCTAssertNil(emptyArray.dtb[0])
        XCTAssertNil(emptyArray.dtb[-1])

        // 字符串数组
        let stringArray = ["a", "b", "c"]
        XCTAssertEqual(stringArray.dtb[1], "b")
        XCTAssertNil(stringArray.dtb[3])
    }
    
}

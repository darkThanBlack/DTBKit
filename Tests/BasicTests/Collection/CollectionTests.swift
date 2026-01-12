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

final class CollectionTests: XCTestCase {

    // MARK: - Collection Extensions Tests
    
    private let intArray = [1, 2, 3, 4, 5]
    private let emptyArray: [Int] = []
    private let stringArray = ["a", "b", "c"]
    
    func testArraySubscripts() throws {
        // 有效取值
        XCTAssertEqual(intArray.dtb[0], 1)
        XCTAssertEqual(intArray.dtb[2], 3)
        XCTAssertEqual(intArray.dtb[4], 5)
        XCTAssertEqual(stringArray.dtb[1], "b")
        XCTAssertNil(stringArray.dtb[3])
        // 无效索引取值
        XCTAssertNil(intArray.dtb[-1])
        XCTAssertNil(intArray.dtb[5])
        XCTAssertNil(intArray.dtb[100])
        XCTAssertNil(intArray.dtb[nil])
        XCTAssertNil(emptyArray.dtb[0])
        XCTAssertNil(emptyArray.dtb[-1])
        
        XCTAssertEqual(intArray.dtb[0..<2], intArray[0..<2])
        XCTAssertEqual(intArray.dtb[-2..<0], [])
        XCTAssertEqual(intArray.dtb[4...6], intArray[4..<intArray.endIndex])
        XCTAssertEqual(intArray.dtb[6...7], [])
    }
    
}

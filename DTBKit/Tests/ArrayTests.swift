//
//  ArrayTests.swift
//  DTBKit_Tests
//
//  Created by moonShadow on 2023/7/13
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import XCTest

final class ArrayTests: XCTestCase {
    
    func testIndex() throws {
        let list = [1, 2, 3]
        
        XCTAssert(list.dtb[-1] == nil)
        XCTAssert(list.dtb[0] == 1)
        XCTAssert(list.dtb[2] == 3)
        XCTAssert(list.dtb[3] == nil)
        XCTAssert(list.dtb[nil] == nil)
    }
}

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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIndex() throws {
        let list = [1, 2, 3]
        
        XCTAssert(list.dtb[0] == 1)
        XCTAssert(list.dtb[3] == nil)
    }
}

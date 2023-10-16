//
//  IntegerTests.swift
//  DTBKit_Tests
//
//  Created by moonShadow on 2023/10/16
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import XCTest

final class IntegerTests: XCTestCase {
    
    
    func testInteger() throws {
        
        let normal: Int = 1
        let normal_32: Int32 = 32
        let normal_64: Int64 = 64
        let pos: Int64 = -64
        
        XCTAssert(normal.dtb.safely?.value == 1)
        XCTAssert(normal_32.dtb.safely?.value == 32)
        
        XCTAssert(2.dtb.min(1, 3, 4).value == 1)
        XCTAssert(2.dtb.max(1, 3, 4).value == 4)
        XCTAssert(-1.dtb.max(1).min(0).value == 0)
        
        XCTAssert(2.dtb.greater(1).value == 2)
        XCTAssert(2.dtb.greater(3).value == 3)
        
        XCTAssert(2.dtb.less(1).value == 1)
        XCTAssert(2.dtb.less(3).value == 2)
        
        XCTAssert(0.dtb.unSafe.nonZero().value == 1)
        
        XCTAssert(1.dtb.int64.isVaild(">=", to: 2) == nil)
        XCTAssert(Int64(1).dtb.isVaild(">=", to: 0)?.value == 1)
        
        XCTAssert(1.dtb.int64.isVaild(">=", to: 2) == nil)
        XCTAssert(Int64(1).dtb.isVaild(">=", to: 0)?.value == 1)
        
        XCTAssert(1.dtb.int64.isIn("(1, 2]") == nil)
        XCTAssert(1.dtb.int64.isIn("[1, 2]")?.value == 1)
        XCTAssert((-2).dtb.int64.isIn("(, )", to: (-3, -1))?.value == -2)
        
        
    }
}

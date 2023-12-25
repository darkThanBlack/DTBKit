//
//  CGRectTests.swift
//  DTBKit_Tests
//
//  Created by moonShadow on 2023/12/25
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import XCTest

final class CGRectTests: XCTestCase {
    
    func testCGRect() throws {
        
        func basic() {
            let r1 = CGRect.zero
            let r2 = CGRect(x: 1, y: 2, width: 3, height: 4)
            let r3 = CGRect(x: 1, y: 2, width: -1, height: 3)
            
            XCTAssert(r1.dtb.isEmpty)
            XCTAssert(r2.dtb.width == 3)
            XCTAssert(r3.dtb.width == 0)
        }
        
        
        basic()
    }
}

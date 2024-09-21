//
//  DTBTests.swift
//  DTBKit_Tests
//
//  Created by moonShadow on 2023/6/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import XCTest

import DTBKit
//import DTBKit_Example

final class DTBKitTests: XCTestCase {
    
    func testDecimal() throws {
        
        XCTAssert(1.dtb.nsDecimal?.string?.value == "1")
        XCTAssert("2.0".dtb.nsDecimal?.double?.value == 2.0)
        // FIXME: pure number
        XCTAssert("3.哈".dtb.nsDecimal?.string?.value == "3")
        XCTAssert("哈哈".dtb.nsDecimal?.string?.value == nil)
    }
}

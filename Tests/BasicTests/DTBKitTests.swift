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
        
        /// 2024-10-17 18:06
        /// 刚刚
        /// 3分钟前
        /// 今天 16:59
        /// 昨天 18:06
        /// 10-09 18:06
        /// 2023-10-16 18:06
        [
            Date().dtb.plusDay(1),
            Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 20),
            Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 200),
            Date(timeIntervalSince1970: Date().timeIntervalSince1970 - 4000),
            Date().dtb.plusDay(-1),
            Date().dtb.plusWeek(-1),
            Date().dtb.plusYear(-1)
        ].forEach { d in
            print(d.dtb.toDynamic())
        }
    }
}

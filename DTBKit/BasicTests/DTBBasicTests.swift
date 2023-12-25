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

//import DTBKit_Basic
import DTBKit_Example

final class DTBBasicTests: XCTestCase {
    
    func testChainer() throws {
        
        func chain_another_wrapper() {
            var a = CGSize(width: 1, height: 2).dtb_set.height(5)
            let b = a.width(3)
            let c = b.width(4)
            
            XCTAssert(a == b.value)
            XCTAssert(b.value == c.value)
            XCTAssert(a == c.value)
            
            XCTAssert(b.value.width == 4)
        }
        
        func chain_struct() {
//            var a = CGSize(width: 1, height: 2)
//            a.dtb.set.width(3)
//            let b = a.dtb.set.height(4).value
//            XCTAssert(a.width == 1)
//            XCTAssert(b.height == 4)
//            XCTAssert(a != b)
        }
        
        chain_another_wrapper()
        chain_struct()
    }
}

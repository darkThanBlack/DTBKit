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
        
        func chainer() {
            var a: CGSize = .dtb.create.width(1).height(2).value
            XCTAssert(a.width == 1)
            XCTAssert(a.height == 2)
            
            var b: CGSize = .dtb.create.width(-3).height(-4).value
            XCTAssert(b.width == 0)
            XCTAssert(b.height == 0)
        }
        
        chainer()
    }
}

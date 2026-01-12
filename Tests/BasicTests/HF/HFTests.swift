//
//  HFTests.swift
//  DTBKit_Basic_Tests
//
//  Created by moonShadow on 2026/1/12
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import XCTest

final class HFTests: XCTestCase {

    func testHF() throws {
        XCTAssertEqual(DTB.Axis.h.nsValue, NSLayoutConstraint.Axis.horizontal)
        XCTAssertEqual(DTB.Axis.v.nsValue, NSLayoutConstraint.Axis.vertical)

        let designSize = DTB.config.designBaseSize
        let screenSize = UIScreen.main.bounds.size
        print("HFTests: designSize=\(designSize), screenSize=\(screenSize)")
        XCTAssertEqual(1.dtb.hf(), 1 * UIScreen.main.bounds.size.width / DTB.config.designBaseSize.width)
        XCTAssertEqual(1.dtb.hf(.scale(.v)), 1 * UIScreen.main.bounds.size.height / DTB.config.designBaseSize.height)
    }
    
}

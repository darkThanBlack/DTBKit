//
//  MathTests.swift
//  DTBKit_Tests
//
//  Created by moonShadow on 2023/6/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import XCTest

final class MathTests: XCTestCase {
    
    private let bad = CGSize(width: -1, height: -1)
    private let normal = CGSize(width: 10.0, height: 20.0)
    
    private let insetBad = UIEdgeInsets(top: 10.0, left: 2.0, bottom: 30.0, right: 4.0)
    private let insetNormal = UIEdgeInsets(top: 1.0, left: 2.0, bottom: 3.0, right: 4.0)
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSizeBasic() throws {
        let emptys = [
            bad,
            CGSize(width: 1, height: 0),
            CGSize(width: 0, height: 0)
        ]
        
        let r1 = emptys.allSatisfy({ $0.dtb.isEmpty == true }) && [normal].allSatisfy({ $0.dtb.isEmpty == false })
        
        XCTAssert(r1)
        XCTAssert(bad.dtb.center == .zero)
        XCTAssert(bad.dtb.shorter == 0.0 && bad.dtb.shorter == 0.0)
        XCTAssert(normal.dtb.center == CGPoint(x: 5.0, y: 10.0))
        XCTAssert(normal.dtb.shorter == 10.0 && normal.dtb.longer == 20.0)
    }
    
    func testSizeFlowBoxs() throws {
        XCTAssert(bad.dtb.inSquare == .zero)
        XCTAssert(normal.dtb.inSquare == CGSize(width: 10.0, height: 10.0))
        XCTAssert(normal.dtb.outSquare == CGSize(width: 20.0, height: 20.0))
        
        XCTAssert(bad.dtb.margin(only: insetNormal) == CGSize(width: 5.0, height: 3.0))
        
        XCTAssert(bad.dtb.padding(only: insetNormal) == .zero)
        XCTAssert(normal.dtb.padding(only: insetNormal) == CGSize(width: 4.0, height: 16.0))
        XCTAssert(normal.dtb.padding(only: insetBad) == CGSize(width: 4.0, height: 0.0))
    }
    
    func testSizeAspects() throws {
        
        XCTAssert(bad.dtb.aspectFit(to: normal) == .zero)
        XCTAssert(normal.dtb.aspectFit(to: CGSize(width: 200.0, height: 100.0)) == CGSize(width: 50.0, height: 100.0))
        XCTAssert(normal.dtb.aspectFill(to: CGSize(width: 200.0, height: 100.0)) == CGSize(width: 200.0, height: 400.0))
    }
}

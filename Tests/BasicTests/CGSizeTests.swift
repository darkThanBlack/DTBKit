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
    
    func testCGSize() throws {
        
        let bad = CGSize(width: -1, height: -1)
        let normal = CGSize(width: 10.0, height: 20.0)
       
        let insetBig = UIEdgeInsets(top: 10.0, left: 2.0, bottom: 30.0, right: 4.0)
        let insetNormal = UIEdgeInsets(top: 1.0, left: 2.0, bottom: 3.0, right: 4.0)
        
        let emptys = [
            bad,
            CGSize(width: 1, height: 0),
            CGSize(width: 0, height: 0)
        ]
        
        let r1 = emptys.allSatisfy({ $0.dtb.isEmpty == true }) && [normal].allSatisfy({ $0.dtb.isEmpty == false })
        
        func basics() {
            XCTAssert(r1)
            XCTAssert(bad.dtb.center == .zero)
            XCTAssert(bad.dtb.shorter == 0.0 && bad.dtb.shorter == 0.0)
            XCTAssert(normal.dtb.center == CGPoint(x: 5.0, y: 10.0))
            XCTAssert(normal.dtb.shorter == 10.0 && normal.dtb.longer == 20.0)
            
            XCTAssert(bad.dtb.inSquare == .zero)
            XCTAssert(normal.dtb.inSquare == CGSize(width: 10.0, height: 10.0))
            XCTAssert(normal.dtb.outSquare == CGSize(width: 20.0, height: 20.0))
        }
        
        func margin() {
            XCTAssert(bad.dtb.margin(all: 2.0).value == CGSize(width: 4.0, height: 4.0))
            XCTAssert(normal.dtb.margin(all: 1.0).value == CGSize(width: 12.0, height: 22.0))
            
            XCTAssert(bad.dtb.margin(dx: 1.0, dy: 2.0).value == CGSize(width: 2.0, height: 4.0))
            XCTAssert(normal.dtb.margin(dx: 2.0, dy: 2.0).value == CGSize(width: 14.0, height: 24.0))
            
            XCTAssert(bad.dtb.margin(only: insetBig).value == CGSize(width: 6.0, height: 40.0))
            XCTAssert(bad.dtb.margin(only: insetNormal).value == CGSize(width: 6.0, height: 4.0))
            XCTAssert(normal.dtb.margin(only: insetNormal).value == CGSize(width: 16.0, height: 24.0))
        }
        
        func padding() {
            XCTAssert(bad.dtb.padding(all: 1.0).value == .zero)
            XCTAssert(normal.dtb.padding(all: 1.0).value == CGSize(width: 8.0, height: 18.0))
            
            XCTAssert(bad.dtb.padding(dx: 1.0, dy: 2.0).value == .zero)
            XCTAssert(normal.dtb.padding(dx: 2.0, dy: 2.0).value == CGSize(width: 6.0, height: 16.0))
            
            XCTAssert(bad.dtb.padding(only: insetNormal).value == .zero)
            XCTAssert(normal.dtb.padding(only: insetNormal).value == CGSize(width: 4.0, height: 16.0))
            XCTAssert(normal.dtb.padding(only: insetBig).value == CGSize(width: 4.0, height: 0.0))
        }
        
        func aspect() {
            let s1 = CGSize(width: 200.0, height: 100.0)
            let s2 = CGSize(width: 100.0, height: 200.0)
            
            let content = CGSize(width: 400.0, height: 400.0)
            
            XCTAssert(content.dtb.aspectFit(to: .zero).value == .zero)
            XCTAssert(CGSize.zero.dtb.aspectFit(to: content).value == .zero)
            
            XCTAssert(s1.dtb.aspectFit(to: content).value == CGSize(width: content.width, height: 200.0))
            XCTAssert(s2.dtb.aspectFit(to: content).value == CGSize(width: 200.0, height: content.height))
            
            XCTAssert(content.dtb.aspectFill(to: .zero).value == .zero)
            XCTAssert(CGSize.zero.dtb.aspectFill(to: content).value == .zero)
            
            XCTAssert(s1.dtb.aspectFill(to: content).value == CGSize(width: 800.0, height: content.height))
            XCTAssert(s2.dtb.aspectFill(to: content).value == CGSize(width: content.width, height: 800.0))
        }
        
        basics()
        margin()
        padding()
        aspect()
    }
}

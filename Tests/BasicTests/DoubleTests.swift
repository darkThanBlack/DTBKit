//
//  DoubleTests.swift
//  DTBKit-Unit-Basic-Tests
//
//  Created by HuChangChang on 2024/1/16.
//

import XCTest
import DTBKit

final class DoubleTests: XCTestCase {
    
    func testDouble() throws {
        
        func formatter() {
            XCTAssert(2.1.dtb.toString(.dtb.decimal())?.value == "2.10")
            XCTAssert(1234.567.dtb.toString(.dtb.decimal())?.value == "1,234.57")
            XCTAssert(2.1.dtb.toString(.dtb.maxDecimal())?.value == "2.1")
            XCTAssert(1234.567.dtb.toString(.dtb.maxDecimal())?.value == "1,234.57")
            XCTAssert(2.1.dtb.toString(.dtb.CNY())?.value == "¥2.10")
            XCTAssert(1234.567.dtb.toString(.dtb.CNY())?.value == "¥1,234.57")
            XCTAssert(2.1.dtb.toString(.dtb.RMB())?.value == "2.1元")
            XCTAssert(1234.567.dtb.toString(.dtb.RMB())?.value == "1,234.57元")
        }
        
        
        XCTAssert(2.0.dtb.toString(NumberFormatter().dtb.decimal(2).rounded(.halfDown).prefix("¥", negative: "-¥").value)?.value == "¥2.00")
        XCTAssert(1234.567.dtb.toString(NumberFormatter().dtb.decimal(2).rounded(.halfDown).prefix("¥", negative: "-¥").value)?.value == "¥1,234.57")
        XCTAssert((-1234.567).dtb.toString(NumberFormatter().dtb.decimal(2).rounded(.halfDown).prefix("¥", negative: "-¥").value)?.value == "-¥1,234.57")
        print(1234.567.dtb.nsDecimal()?.plus(1.245, scale: 2, rounding: .down)?.double()?.value ?? 0.0)
        print(1234.567.dtb.nsDecimal()?.minus(1.245, scale: 2, rounding: .plain)?.double()?.value ?? 0.0)
        print(1234.567.dtb.nsDecimal()?.multi(1.245, scale: 2, rounding: .plain)?.double()?.value ?? 0.0)
        print(1234.567.dtb.nsDecimal()?.div(1.245, scale: 2, rounding: .plain)?.double()?.value ?? 0.0)
        print(1234.567.dtb.nsDecimal()?.power(2, scale: 2, rounding: .plain)?.double()?.value ?? 0.0)
        print(1234.567.dtb.nsDecimal()?.multiPower10(2, scale: 2, rounding: .plain)?.double()?.value ?? 0.0)
        
        print(1.26.dtb.places(1))
        print((-1.26).dtb.places(1))
    }

}

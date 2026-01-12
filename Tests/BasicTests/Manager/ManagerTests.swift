//
//  ManagerTests.swift
//  DTBKit_Basic_Tests
//
//  Created by moonShadow on 2026/1/12
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import XCTest

final class ManagerTests: XCTestCase {
    
    func testAppManagerBasicExtensions() throws {
#if DEBUG
        XCTAssertTrue(DTB.app.isDebug())
#else
        XCTAssertFalse(DTB.app.isDebug())
#endif
        XCTAssertEqual(DTB.app.displayName, (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? "")
        XCTAssertEqual(DTB.app.version, Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String)
        XCTAssertEqual(DTB.app.build, Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String)
    }
    
}

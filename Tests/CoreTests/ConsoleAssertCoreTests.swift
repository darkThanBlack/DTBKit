//
//  ConsoleAssertCoreTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2026-11-26
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//

import XCTest

#if canImport(DTBKit)
import DTBKit
#elseif canImport(DTBKit_Core)
import DTBKit_Core
#endif

final class ConsoleAssertCoreTests: XCTestCase {

    private final class AssertRecorder: DTB.Providers.ConsoleProvider {

        private(set) var assertions: [String] = []

        func log(_ item: Any, file: String, line: Int, function: String) {}

        func error(_ item: Any?, file: String, line: Int, function: String) {}

        func assert(_ item: Any?, file: String, line: Int, function: String) {
            assertions.append(item.map({ "\($0)" }) ?? "nil")
        }
    }

    func testAssertForwardsToProvider() {
        let recorder = AssertRecorder()
        DTB.Providers.register(recorder, key: DTB.Providers.consoleKey)
        defer { DTB.Providers.unregister(DTB.Providers.consoleKey) }

        DTB.console.assert("boom")
        DTB.console.assert()

        XCTAssertEqual(recorder.assertions, ["boom", "nil"])
    }
}

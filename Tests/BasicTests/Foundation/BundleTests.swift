//
//  BundleCoreTests.swift
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
#elseif canImport(DTBKit_Basic)
import DTBKit_Basic
#endif

final class BundleTests: XCTestCase {

    private final class BundleToken {}

    private let cacheKey = DTB.ConstKey<[URL]>("dtb.all.bundles.url")

    override func tearDown() {
        DTB.app.set(nil, key: cacheKey)
        super.tearDown()
    }

    func testCreateFromClass() {
        let bundle = Bundle.dtb.create(BundleToken.self)
        XCTAssertEqual(bundle?.bundleURL, Bundle(for: BundleToken.self).bundleURL)
    }

    func testCreateFromURL() {
        let bundle = Bundle.dtb.create(Bundle.main.bundleURL)
        XCTAssertEqual(bundle?.bundleURL, Bundle.main.bundleURL)
    }

    func testCreateFromUnknownParam() {
        XCTAssertNil(Bundle.dtb.create("dtb.not.exist.bundle"))
        XCTAssertNil(Bundle.dtb.create(123))
        XCTAssertNil(Bundle.dtb.create(nil))
    }

    func testCreateFromName() {
        let tokenBundle = Bundle(for: BundleToken.self)
        let name = tokenBundle.bundleURL.deletingPathExtension().lastPathComponent
        DTB.app.set([tokenBundle.bundleURL], key: cacheKey)
        let bundle = Bundle.dtb.create(name)
        XCTAssertEqual(bundle?.bundleURL, tokenBundle.bundleURL)
    }

    func testAllBundleUrls() {
        let urls = Bundle.dtb.allBundleUrls()
        XCTAssertTrue(urls.allSatisfy { $0.pathExtension == "bundle" })
        XCTAssertEqual(Bundle.dtb.allBundleUrls(), urls)
    }

    func testAllBundleUrlsCached() {
        let tokenBundle = Bundle(for: BundleToken.self)
        DTB.app.set([tokenBundle.bundleURL], key: cacheKey)
        XCTAssertEqual(Bundle.dtb.allBundleUrls(), [tokenBundle.bundleURL])
    }
}

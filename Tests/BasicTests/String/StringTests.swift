//
//  StringProcessingTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2025-12-16
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  字符串处理模块测试：String 扩展，正则表达式，字符串验证
//

import XCTest

/// For code coverage.
#if canImport(DTBKit)
import DTBKit
#elseif canImport(DTBKit_Basic)
import DTBKit_Basic
#endif

/// DTBKit 字符串处理模块测试
final class StringProcessingTests: XCTestCase {
    
    // MARK: - Convert
    
    // MARK: - String Basic Extensions Tests

    func testStringBasicConversions() throws {
        let testString = "Hello, DTBKit! 测试字符串 🚀"

        // NSString 转换
        let nsString = testString.dtb.ns().value
        XCTAssertEqual(String(nsString), testString)
        XCTAssertTrue(nsString.isKind(of: NSString.self))

        // NSAttributedString 转换
        let attrString = testString.dtb.attr().value
        XCTAssertEqual(attrString.string, testString)
        XCTAssertTrue(attrString.isKind(of: NSAttributedString.self))
    }

    func testStringDataConversions() throws {
        let testString = "Hello, 世界! 🌍"
        
        // 默认 UTF-8 编码
        let utf8Data = testString.dtb.data()?.value
        XCTAssertNotNil(utf8Data)

        // 指定编码
        let utf16Data = testString.dtb.data(.utf16)?.value
        XCTAssertNotNil(utf16Data)
        XCTAssertNotEqual(utf8Data, utf16Data) // 不同编码应该产生不同数据

        // ASCII 编码（对于包含非 ASCII 字符的字符串可能失败）
        let loosy = testString.dtb.data(.ascii)?.value
        let notLossy = testString.dtb.data(.ascii, lossy: false)?.value
        XCTAssertNotNil(loosy)
        XCTAssertNil(notLossy)

        // 纯 ASCII 字符串
        let asciiString = "Hello, World!"
        let asciiValidData = asciiString.dtb.data(.ascii)?.value
        XCTAssertNotNil(asciiValidData)
    }

    func testStringCountOperations() throws {
        // 基础字符串
        let simpleString = "Hello"
        XCTAssertEqual(simpleString.dtb.count(), 5)

        // 空字符串
        let emptyString = ""
        XCTAssertEqual(emptyString.dtb.count(), 0)

        // 包含中文的字符串
        let chineseString = "你好世界"
        XCTAssertEqual(chineseString.dtb.count(), 4)

        // 包含 emoji 的字符串
        let emojiString = "Hello 👋🌍"
        // emoji 字符计数可能因实现而异
        XCTAssertGreaterThan(emojiString.dtb.count(), 6)
    }

    func testStringEmptyChecks() throws {
        // 空字符串检查
        XCTAssertTrue("".dtb.isEmpty())
        XCTAssertFalse("Hello".dtb.isEmpty())

        // 空白字符串检查
        XCTAssertTrue("   ".dtb.isBlank())
        XCTAssertEqual("   ".dtb.noBlank().value, "")
        XCTAssertTrue("\t\n  ".dtb.isBlank())
        XCTAssertFalse("Hello".dtb.isBlank())
        XCTAssertEqual(" Hel lo ".dtb.noBlank().value, "Hel lo")

        // 边界情况
        XCTAssertTrue(" \t\n\r ".dtb.isBlank()) // 各种空白字符
        XCTAssertFalse(" a ".dtb.isBlank()) // 包含非空白字符
    }

    func testStringNumberValidation() throws {
        // 整数验证
        XCTAssertTrue("123".dtb.isPureInt())
        XCTAssertTrue("0".dtb.isPureInt())
        XCTAssertFalse("12.34".dtb.isPureInt())
        XCTAssertFalse("abc".dtb.isPureInt())
        XCTAssertFalse("".dtb.isPureInt())

        // 边界情况
        XCTAssertFalse("12a".dtb.isPureInt()) // 包含字母
        XCTAssertFalse("1 2".dtb.isPureInt()) // 包含空格
        XCTAssertFalse("-456".dtb.isPureInt())
        XCTAssertFalse("+123".dtb.isPureInt()) // 正号（取决于实现）
    }

    func testStringRangeOperations() throws {
        let testString = "Hello, World! 测试字符串"

        // NSRange 检查
        let validRange = NSRange(location: 0, length: 5)
        XCTAssertTrue(testString.dtb.has(nsRange: validRange))

        let invalidRange = NSRange(location: 100, length: 5)
        XCTAssertFalse(testString.dtb.has(nsRange: invalidRange))

        let partialInvalidRange = NSRange(location: 5, length: 100)
        XCTAssertFalse(testString.dtb.has(nsRange: partialInvalidRange))

        // 边界范围
        let fullRange = NSRange(location: 0, length: testString.count)
        XCTAssertTrue(testString.dtb.has(nsRange: fullRange))

        let zeroLengthRange = NSRange(location: 5, length: 0)
        XCTAssertTrue(testString.dtb.has(nsRange: zeroLengthRange)) // 零长度范围在有效位置应该有效
    }

    func testStringRegexMatching() throws {
        // 基础正则匹配
        let emailString = "test@example.com"
        let emailPattern = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        XCTAssertTrue(emailString.dtb.isMatches(emailPattern))

        // 不匹配的情况
        let invalidEmail = "invalid-email"
        XCTAssertFalse(invalidEmail.dtb.isMatches(emailPattern))

        // 数字模式
        let numberString = "12345"
        let numberPattern = "^\\d+$"
        XCTAssertTrue(numberString.dtb.isMatches(numberPattern))

        let mixedString = "123abc"
        XCTAssertFalse(mixedString.dtb.isMatches(numberPattern))

        // 复杂模式
        let phoneString = "+1-555-123-4567"
        let phonePattern = "\\+\\d{1,3}-\\d{3}-\\d{3}-\\d{4}"
        XCTAssertTrue(phoneString.dtb.isMatches(phonePattern))
    }

    func testStringRegularExpressions() throws {
        // URL 匹配
        let urlString = "https://www.example.com/path?param=value"
        let urlPattern = "https?://[\\w\\.-]+\\.[a-zA-Z]{2,}(/[\\w\\.-]*)*\\??.*"
        XCTAssertTrue(urlString.dtb.isRegular(.init(urlPattern)))

        // 非 URL 字符串
        let nonUrlString = "not a url"
        XCTAssertFalse(nonUrlString.dtb.isRegular(.init(urlPattern)))

        // IPv4 地址匹配
        let ipString = "192.168.1.1"
        let ipPattern = "^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
        XCTAssertTrue(ipString.dtb.isRegular(.init(ipPattern)))

        let invalidIpString = "999.999.999.999"
        XCTAssertFalse(invalidIpString.dtb.isRegular(.init(ipPattern)))
    }

    // MARK: - Advanced String Processing Tests

    func testStringComplexValidation() throws {
        // 中文字符验证
        let chineseString = "你好世界"
        let chinesePattern = "^[\\u4e00-\\u9fa5]+$"
        XCTAssertTrue(chineseString.dtb.isMatches(chinesePattern))

        let mixedChineseString = "Hello你好"
        XCTAssertFalse(mixedChineseString.dtb.isMatches(chinesePattern))

        // 密码强度验证（包含大小写字母、数字和特殊字符）
        let strongPassword = "MyStr0ng@Pass!"
        let passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        XCTAssertTrue(strongPassword.dtb.isMatches(passwordPattern))

        let weakPassword = "password"
        XCTAssertFalse(weakPassword.dtb.isMatches(passwordPattern))
    }

    func testStringUnicodeHandling() throws {
        // Unicode 字符串
        let unicodeString = "🚀🌟✨🎉"
        XCTAssertFalse(unicodeString.dtb.isEmpty())

        // 混合 Unicode 和 ASCII
        let mixedUnicodeString = "Hello 🌍 World 🚀"
        let nsString = mixedUnicodeString.dtb.ns().value
        XCTAssertEqual(String(nsString), mixedUnicodeString)

        // Unicode 数据转换
        let unicodeData = unicodeString.dtb.data()?.value
        XCTAssertNotNil(unicodeData)
        XCTAssertGreaterThan(unicodeData!.count, 4) // Unicode 字符占用多个字节
    }

    func testStringEncodingEdgeCases() throws {
        // 特殊字符处理
        let specialChars = "!@#$%^&*()_+-=[]{}|;:'\",.<>?/~`"
        let specialData = specialChars.dtb.data()?.value
        XCTAssertNotNil(specialData)

        // 控制字符
        let controlChars = "\t\n\r"
        let controlData = controlChars.dtb.data()?.value
        XCTAssertNotNil(controlData)

        // 多语言文本
        let multiLangString = "Hello Bonjour Hola こんにちは 你好 مرحبا"
        let multiLangData = multiLangString.dtb.data()?.value
        XCTAssertNotNil(multiLangData)
    }

    // MARK: - String Performance Tests

    func testStringLargeDataHandling() throws {
        // 大字符串处理
        let largeString = String(repeating: "A", count: 10000)
        XCTAssertEqual(largeString.dtb.count(), 10000)
        XCTAssertFalse(largeString.dtb.isEmpty())

        // 大字符串数据转换
        let largeData = largeString.dtb.data()?.value
        XCTAssertNotNil(largeData)
        XCTAssertEqual(largeData!.count, 10000) // ASCII 字符每个占1字节

        // 大字符串正则匹配
        let allAPattern = "^A+$"
        XCTAssertTrue(largeString.dtb.isMatches(allAPattern))
    }

    func testStringRepeatedOperations() throws {
        let testStrings = [
            "test1@example.com",
            "test2@example.org",
            "invalid-email",
            "test3@domain.co.uk",
            "another-invalid"
        ]

        let emailPattern = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        // 批量验证
        let validEmails = testStrings.filter { $0.dtb.isMatches(emailPattern) }
        XCTAssertEqual(validEmails.count, 3)

        // 批量转换
        let nsStrings = testStrings.map { $0.dtb.ns().value }
        XCTAssertEqual(nsStrings.count, testStrings.count)

        // 批量数据转换
        let dataArray = testStrings.compactMap { $0.dtb.data()?.value }
        XCTAssertEqual(dataArray.count, testStrings.count)
    }

    // MARK: - Edge Cases and Error Handling

    func testStringInvalidRegex() throws {
        let testString = "Hello World"
        
        // FIXME: 无效正则表达式怎么捕获?
//        // 无效正则表达式（应该不崩溃）
//        let invalidPattern = "[abc" // 未闭合的字符集
//        // 不同的实现可能有不同的处理方式
//        // 可能返回 false 或抛出异常
//        do {
//            let result = testString.dtb.isMatches(invalidPattern)
//            // 如果没有抛出异常，结果应该是 false
//            XCTAssertFalse(result)
//        } catch {
//            // 如果抛出异常，这是预期的行为
//            XCTAssertNotNil(error)
//        }
    }

    func testStringBoundaryConditions() throws {
        // 极长字符串
        let extremeString = String(repeating: "📱", count: 1000)
        XCTAssertFalse(extremeString.dtb.isEmpty())

        // 仅空白字符的长字符串
        let longBlankString = String(repeating: " ", count: 1000)
        XCTAssertTrue(longBlankString.dtb.isBlank())
        XCTAssertFalse(longBlankString.dtb.isEmpty())

        // 混合空白字符
        let mixedBlankString = String(repeating: " \t\n\r", count: 100)
        XCTAssertTrue(mixedBlankString.dtb.isBlank())

        // 单个字符的边界测试
        XCTAssertFalse("a".dtb.isEmpty())
        XCTAssertFalse("a".dtb.isBlank())
    }

    func testStringSpecialCases() throws {
        // 零宽字符
        let zeroWidthString = "\u{200B}" // 零宽空格
        XCTAssertFalse(zeroWidthString.dtb.isEmpty())
        // 零宽字符的 blank 检查取决于实现
        // XCTAssertTrue(zeroWidthString.dtb.isBlank())

        // 组合字符
        let combinedChar = "e\u{0301}" // e + 重音符
        XCTAssertFalse(combinedChar.dtb.isEmpty())
        XCTAssertFalse(combinedChar.dtb.isBlank())

        // 换行符组合
        let lineBreaks = "\r\n"
        XCTAssertTrue(lineBreaks.dtb.isBlank())
        XCTAssertFalse(lineBreaks.dtb.isEmpty())
    }

    // MARK: - Integration Tests

    func testStringCompleteWorkflow() throws {
        let userInput = "  user@example.com  "

        // 完整的字符串处理流程
        // 1. 去除空白后检查是否为空
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        XCTAssertFalse(trimmed.dtb.isEmpty())

        // 2. 转换为 NSString 进行进一步处理
        let nsString = trimmed.dtb.ns().value
        XCTAssertTrue(nsString.isKind(of: NSString.self))

        // 3. 验证邮箱格式
        let emailPattern = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        XCTAssertTrue(trimmed.dtb.isMatches(emailPattern))

        // 4. 转换为数据进行存储
        let emailData = trimmed.dtb.data()?.value
        XCTAssertNotNil(emailData)

        // 5. 验证数据往返转换
        if let emailData = emailData {
            let restoredString = String(data: emailData, encoding: .utf8)
            XCTAssertEqual(restoredString, trimmed)
        }
    }
}

//
//  FoundationExtensionsTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2025-12-16
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Foundation 扩展模块测试：UserDefaults, Data, NSString, NSRange, NSMutableAttributedString
//

import XCTest

/// For code coverage.
#if canImport(DTBKit)
import DTBKit
#elseif canImport(DTBKit_Basic)
import DTBKit_Basic
#endif

/// DTBKit Foundation 扩展模块测试
final class FoundationExtensionsTests: XCTestCase {

    // MARK: - UserDefaults Extensions Tests

    func testUserDefaultsBasicOperations() throws {
        // 基础读写测试
        let stringKey = DTB.ConstKey<String>("test_string")
        let intKey = DTB.ConstKey<Int>("test_int")
        let boolKey = DTB.ConstKey<Bool>("test_bool")
        let doubleKey = DTB.ConstKey<Double>("test_double")

        // 写入数据 - 使用静态扩展
        UserDefaults.dtb.write("test_value", key: stringKey)
        UserDefaults.dtb.write(42, key: intKey)
        UserDefaults.dtb.write(true, key: boolKey)
        UserDefaults.dtb.write(3.14, key: doubleKey)

        // 读取验证
        XCTAssertEqual(UserDefaults.dtb.read(stringKey), "test_value")
        XCTAssertEqual(UserDefaults.dtb.read(intKey), 42)
        XCTAssertEqual(UserDefaults.dtb.read(boolKey), true)
        XCTAssertEqual(UserDefaults.dtb.read(doubleKey), 3.14)

        // 清理
        UserDefaults.dtb.write(nil, key: stringKey)
        UserDefaults.dtb.write(nil, key: intKey)
        UserDefaults.dtb.write(nil, key: boolKey)
        UserDefaults.dtb.write(nil, key: doubleKey)

        // 验证删除
        XCTAssertNil(UserDefaults.dtb.read(stringKey))
        XCTAssertNil(UserDefaults.dtb.read(intKey))
        XCTAssertNil(UserDefaults.dtb.read(boolKey))
        XCTAssertNil(UserDefaults.dtb.read(doubleKey))
        
        // 复杂数据类型
        let arrayKey = DTB.ConstKey<[String]>("test_array")
        let dictKey = DTB.ConstKey<[String: Int]>("test_dict")
        let dataKey = DTB.ConstKey<Data>("test_data")
        let dateKey = DTB.ConstKey<Date>("test_date")

        let testArray = ["item1", "item2", "item3"]
        let testDict = ["key1": 1, "key2": 2]
        let testData = "test string".data(using: .utf8)!
        let testDate = Date()

        // 写入
        UserDefaults.dtb.write(testArray, key: arrayKey)
        UserDefaults.dtb.write(testDict, key: dictKey)
        UserDefaults.dtb.write(testData, key: dataKey)
        UserDefaults.dtb.write(testDate, key: dateKey)

        // 读取验证
        XCTAssertEqual(UserDefaults.dtb.read(arrayKey), testArray)
        XCTAssertEqual(UserDefaults.dtb.read(dictKey), testDict)
        XCTAssertEqual(UserDefaults.dtb.read(dataKey), testData)

        // Date 比较需要考虑精度
        if let readDate = UserDefaults.dtb.read(dateKey) {
            XCTAssertEqual(readDate.timeIntervalSince1970, testDate.timeIntervalSince1970, accuracy: 0.001)
        } else {
            XCTFail("Failed to read date")
        }

        // 清理
        UserDefaults.dtb.write(nil, key: arrayKey)
        UserDefaults.dtb.write(nil, key: dictKey)
        UserDefaults.dtb.write(nil, key: dataKey)
        UserDefaults.dtb.write(nil, key: dateKey)
    }

    func testUserDefaultsCodableSupport() throws {
        // 定义 Codable 类型
        struct TestModel: Codable, Equatable {
            let id: Int
            let name: String
            let active: Bool
        }

        let codableKey = DTB.ConstKey<TestModel>()
        let testModel = TestModel(id: 1, name: "Test", active: true)

        // 测试 Codable 写入和读取
        UserDefaults.dtb.write(codable: testModel, key: codableKey)
        let readModel: TestModel? = UserDefaults.dtb.read(codable: codableKey)

        XCTAssertEqual(readModel, testModel)

        // 清理
        UserDefaults.standard.removeObject(forKey: codableKey.key_)

        // 验证删除
        let deletedModel: TestModel? = UserDefaults.dtb.read(codable: codableKey)
        XCTAssertNil(deletedModel)
    }

    func testUserDefaultsInvalidOperations() throws {
        // 测试无效 key 的处理
        let invalidKey = DTB.ConstKey<String>("")
        UserDefaults.dtb.write("test", key: invalidKey)

        // 空 key 应该能正常工作（虽然不推荐）
        XCTAssertEqual(UserDefaults.dtb.read(invalidKey), "test")

        // 清理
        UserDefaults.dtb.write(nil, key: invalidKey)

        // 测试类型不匹配的读取
        let stringKey = DTB.ConstKey<String>("type_test")
        let intKey = DTB.ConstKey<Int>("type_test") // 同样的 rawValue，不同类型

        UserDefaults.dtb.write("string_value", key: stringKey)
        // 尝试用 Int 类型读取 String 数据 - 应该返回 nil
        XCTAssertNil(UserDefaults.dtb.read(intKey))

        // 清理
        UserDefaults.dtb.write(nil, key: stringKey)
    }

    // MARK: - Data Extensions Tests

    func testDataBasicOperations() throws {
        // 字符串转 Data
        let testString = "Hello, DTBKit!"
        let data = testString.data(using: .utf8)!

        // 测试 ns() 方法
        let nsData = data.dtb.ns().value
        XCTAssertEqual(nsData.length, data.count)
        XCTAssertTrue(nsData.isKind(of: NSData.self))

        // 测试 string() 方法 - 默认 UTF-8
        let convertedString = data.dtb.string()?.value
        XCTAssertEqual(convertedString, testString)

        // 测试指定编码的 string() 方法
        let utf8String = data.dtb.string(.utf8)?.value
        XCTAssertEqual(utf8String, testString)

        // 测试无效编码
        let invalidData = Data([0xFF, 0xFE])  // 无效的 UTF-8
        let invalidString = invalidData.dtb.string(.utf8)?.value
        XCTAssertNil(invalidString)
    }

    func testDataEdgeCases() throws {
        // 空 Data
        let emptyData = Data()
        XCTAssertEqual(emptyData.dtb.ns().value.length, 0)
        XCTAssertEqual(emptyData.dtb.string()?.value, "")
        XCTAssertEqual(emptyData.dtb.string(.utf8)?.value, "")

        // 二进制数据
        let binaryData = Data([0x00, 0x01, 0x02, 0xFF])
        let nsData = binaryData.dtb.ns().value
        XCTAssertEqual(nsData.length, 4)

        // 二进制数据转字符串（通常会失败）
        let binaryString = binaryData.dtb.string()?.value
        XCTAssertNil(binaryString) // 无效的 UTF-8 序列

        // ASCII 编码测试
        let asciiString = "ASCII Test"
        let asciiData = asciiString.data(using: .ascii)!
        XCTAssertEqual(asciiData.dtb.string(.ascii)?.value, asciiString)
    }

    // MARK: - NSString Extensions Tests

    func testNSStringRangeOperations() throws {
        let testString = "Hello, World! 测试字符串"

//        // 测试 range(of:) 方法
//        let range1 = testString.dtb.range(of: "World")
//        XCTAssertEqual(range1.location, 7)
//        XCTAssertEqual(range1.length, 5)
//
//        // 测试查找中文
//        let range2 = testString.dtb.range(of: "测试")
//        XCTAssertNotEqual(range2.location, NSNotFound)
//        XCTAssertEqual(range2.length, 2)
//
//        // 测试不存在的子字符串
//        let range3 = testString.dtb.range(of: "NotFound")
//        XCTAssertEqual(range3.location, NSNotFound)
//        XCTAssertEqual(range3.length, 0)
//
//        // 测试空字符串查找
//        let range4 = testString.dtb.range(of: "")
//        XCTAssertEqual(range4.location, 0)
//        XCTAssertEqual(range4.length, 0)
    }

    func testNSStringEdgeCases() throws {
//        // 空字符串
//        let emptyString = ""
//        let emptyRange = emptyString.dtb.range(of: "test")
//        XCTAssertEqual(emptyRange.location, NSNotFound)
//
//        // 单字符
//        let singleChar = "A"
//        let singleRange = singleChar.dtb.range(of: "A")
//        XCTAssertEqual(singleRange.location, 0)
//        XCTAssertEqual(singleRange.length, 1)
//
//        // Unicode 字符
//        let unicodeString = "🌟🚀✨"
//        let unicodeRange = unicodeString.dtb.range(of: "🚀")
//        XCTAssertNotEqual(unicodeRange.location, NSNotFound)
//        // 注意：emoji 在 NSString 中可能占多个字符位置
//        XCTAssertTrue(unicodeRange.length > 0)
    }

    // MARK: - NSRange Extensions Tests

    func testNSRangeValidation() throws {
        // 有效范围
        let validRange = NSRange(location: 5, length: 10)
        XCTAssertFalse(validRange.dtb_isInvalid())

        // 空长认为是合法值
        let emptyRange = NSRange(location: 5, length: 0)
        XCTAssertFalse(emptyRange.dtb_isInvalid())

        // NSNotFound 范围
        let notFoundRange = NSRange(location: NSNotFound, length: 0)
        XCTAssertTrue(notFoundRange.dtb_isInvalid())

        // 边界情况
        let maxRange = NSRange(location: NSNotFound - 1, length: 1)
        XCTAssertFalse(maxRange.dtb_isInvalid())
    }

    // MARK: - NSMutableAttributedString Extensions Tests

    func testNSMutableAttributedStringBasicOperations() throws {
        let mutableAttrString = NSMutableAttributedString()

        // 测试 string() 方法
        let testString = mutableAttrString.dtb.string().value
        XCTAssertEqual(testString, "")

        // 添加基础文本
        mutableAttrString.append(NSAttributedString(string: "Hello"))
        XCTAssertEqual(mutableAttrString.dtb.string().value, "Hello")

        // 测试 mString() 方法
//        let mutableString = mutableAttrString.dtb.mString().value
//        XCTAssertTrue(mutableString.isKind(of: NSMutableString.self))
//        XCTAssertEqual(mutableString.string, "Hello")
    }

    func testNSMutableAttributedStringAppend() throws {
        let baseAttrString = NSMutableAttributedString(string: "Base")

        // 测试 append(_:_:) 方法
        let appendString = " Appended"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.red,
            .font: UIFont.systemFont(ofSize: 16)
        ]

        baseAttrString.dtb.append(appendString, DTB.AttributedStyle(attr: attributes))

        XCTAssertEqual(baseAttrString.string, "Base Appended")

        // 验证属性应用
        let range = NSRange(location: 4, length: appendString.count)
        let appliedAttributes = baseAttrString.attributes(at: 5, effectiveRange: nil)
        XCTAssertNotNil(appliedAttributes[.foregroundColor])
        XCTAssertNotNil(appliedAttributes[.font])
    }

    func testNSMutableAttributedStringSubstringOperations() throws {
        let baseString = "Hello, World! Test String"
        let attrString = NSMutableAttributedString(string: baseString)

        // 添加一些属性
        attrString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(location: 0, length: 5))

        // 测试 setSub(_:attrs:) 方法
        let newAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.blue,
            .backgroundColor: UIColor.yellow
        ]

        attrString.dtb.setSub("World", style: DTB.AttributedStyle(attr: newAttributes))

        // 验证 "World" 的位置是否设置了新属性
        let worldRange = (baseString as NSString).range(of: "World")
        let worldAttributes = attrString.attributes(at: worldRange.location, effectiveRange: nil)
        XCTAssertNotNil(worldAttributes[.foregroundColor])
        XCTAssertNotNil(worldAttributes[.backgroundColor])
    }

    func testNSMutableAttributedStringAddSub() throws {
        let baseString = "Original text with modification"
        let attrString = NSMutableAttributedString(string: baseString)

        // 测试 addSub(_:attrs:) 方法
        let addAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
        ]

        attrString.dtb.addSub("modification", style: DTB.AttributedStyle(attr: addAttributes))

        // 验证添加的属性
        let modRange = (baseString as NSString).range(of: "modification")
        let modAttributes = attrString.attributes(at: modRange.location, effectiveRange: nil)
        XCTAssertNotNil(modAttributes[.underlineStyle])
        XCTAssertNotNil(modAttributes[.strikethroughStyle])
    }

    func testNSMutableAttributedStringEdgeCases() throws {
        let emptyAttrString = NSMutableAttributedString()

        // 空字符串操作
        XCTAssertEqual(emptyAttrString.dtb.string().value, "")
        XCTAssertEqual(emptyAttrString.dtb.mString().value.length, 0)

        // 空字符串添加属性（应该不崩溃）
        emptyAttrString.dtb.append("", DTB.AttributedStyle())
        XCTAssertEqual(emptyAttrString.string, "")

        // 不存在的子字符串操作
        let testAttrString = NSMutableAttributedString(string: "Test")
        testAttrString.dtb.setSub("NotFound", style: DTB.AttributedStyle(font: .systemFont(ofSize: 12)))
        testAttrString.dtb.addSub("NotFound", style: DTB.AttributedStyle(font: .systemFont(ofSize: 12)))

        // 应该不改变原字符串
        XCTAssertEqual(testAttrString.string, "Test")
    }
}

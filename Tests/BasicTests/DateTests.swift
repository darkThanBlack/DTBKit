//
//  TimeModuleTests.swift
//  DTBKit_Tests
//
//  Created by Claude on 2025-12-16
//  Copyright © 2025 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  时间模块测试：Date 扩展，时间格式化，动态时间显示
//

import XCTest

/// For code coverage.
#if canImport(DTBKit)
import DTBKit
#elseif canImport(DTBKit_Basic)
import DTBKit_Basic
#endif

/// DTBKit 时间模块测试
final class TimeModuleTests: XCTestCase {
    
    /// 1970-01-01 08:00:00 UTC
    static let unixDate = Date(timeIntervalSince1970: 0)
    
    static let plan_stamp: [Int] = [
        -86400,      // 1969-12-31
         -1,          // 1970年之前
         0,           // Unix epoch
         946684800,   // 2000-01-01 00:00:00 的时间戳
         1609459200,  // 2021-01-01 00:00:00 的时间戳
         1640995200,  // 2022-01-01 00:00:00 的时间戳
         1672531200,  // 2023-01-01 00:00:00 的时间戳
         1704067200,  // 2024-01-01 00:00:00 的时间戳
         2147483647,  // 2038年问题 (32位时间戳最大值)
         4102444800   // 2100-01-01 00:00:00
    ]
    
    static let plan_stamp_f: [Double] = [
        0,
        0.499,
        0.511
    ]
    
    static let plan_stamp_str: [String] = [
        "0",
        "0.499",
        "0.511",
        "946684800"  // 2000-01-01 00:00:00 的时间戳
    ]
    
    static let plan_stamp_str_err: [String] = [
        "",
        "NotANumber"
    ]
    
//    [
//        60,          // 1分钟的秒数
//        3600,        // 1小时的秒数
//        86400,       // 1天的秒数
//        604800,      // 1周的秒数
//        2629746,     // 1个月的平均秒数
//        31556952,    // 1年的平均秒数
//
//    ]
    
    // MARK: - Convert
    
    func testDateConvert() throws {
        Self.plan_stamp.forEach({
            XCTAssertEqual($0.dtb.sDate().value, Date(timeIntervalSince1970: TimeInterval($0)))
            XCTAssertEqual($0.dtb.msDate().value, Date(timeIntervalSince1970: TimeInterval($0) / 1000.0))
        })
        Self.plan_stamp_f.forEach({
            XCTAssertEqual($0.dtb.sDate().value, Date(timeIntervalSince1970: TimeInterval($0)))
            XCTAssertEqual($0.dtb.msDate().value, Date(timeIntervalSince1970: TimeInterval($0) / 1000.0))
        })
        Self.plan_stamp_str.forEach({ item in
            let s: Date? = {
                if let t = TimeInterval(item) {
                    return Date(timeIntervalSince1970: t)
                }
                return nil
            }()
            let ms: Date? = {
                if let t = TimeInterval(item) {
                    return Date(timeIntervalSince1970: t / 1000.0)
                }
                return nil
            }()
            XCTAssertEqual(item.dtb.sDate()?.value, s)
            XCTAssertEqual(item.dtb.msDate()?.value, ms)
        })
        Self.plan_stamp_str_err.forEach({
            XCTAssertNil($0.dtb.sDate()?.value)
            XCTAssertNil($0.dtb.msDate()?.value)
        })
    }
    
    // MARK: - Format
    
    func testDateFormat() throws {
        /// (Date, formatString, result)
        let pair = [
            (Self.unixDate, "", "1970-01-01 08:00"),  // 尝试传空字符串
            (Self.unixDate, "yyyy-MM-dd HH:mm", "1970-01-01 08:00"),
            (Self.unixDate, "yyyy-MM-dd'T'HH:mm:ss'Z'", "1970-01-01T08:00:00Z"),
            (Self.unixDate, "hh:mm:ss", "08:00:00")
        ]
        pair.forEach({
            // Date -> String
            XCTAssertEqual($0.0.dtb.toString($0.1), $0.2)
            // FIXME: String -> Date
//            XCTAssertEqual($0.2.dtb.toDate($0.1), $0.0)
        })
    }
    
    // FIXME: 实现需要明确
    func testDateMinutesCalculation() throws {
//        let testDate = Date(timeIntervalSince1970: 1577836800) // 2020-01-01 00:00:00 UTC
//
//        // 一天内的分钟数（从00:00开始）
//        let minutesInDay = testDate.dtb.minutesString()
//        XCTAssertNotNil(minutesInDay)
//
//        // 测试不同时间的分钟计算
//        let noonDate = Date(timeIntervalSince1970: 1577836800 + 12 * 3600) // 12:00
//        let noonMinutes = noonDate.dtb.minutesString()
//        XCTAssertNotEqual(minutesInDay, noonMinutes)
    }

    // FIXME: 实现需要明确
    func testWeekdayString() throws {
//        // 使用已知的星期几日期进行测试
//        let monday = Date(timeIntervalSince1970: 1577836800) // 2020-01-01 是星期三
//        let weekdayString = monday.dtb.weekDayString()
//        XCTAssertNotNil(weekdayString)
//        XCTAssertFalse(weekdayString.isEmpty)
//
//        // 测试自定义格式
//        let shortWeekday = monday.dtb.weekDayString("E")
//        XCTAssertNotNil(shortWeekday)
//        XCTAssertFalse(shortWeekday.isEmpty)
    }

    // MARK: - Date Calculation Extensions Tests

    func testDateAdditions() throws {
        let baseDate = Date(timeIntervalSince1970: 1577836800) // 2020-01-01

        // 测试不同单位的添加
        let components = DateComponents(day: 1, hour: 2, minute: 30)
        guard let addedDate = baseDate.dtb.adding(by: components)?.value,
              let nextDay = baseDate.dtb.addingDay(1)?.value,
              let nextWeek = baseDate.dtb.addingWeek(1)?.value,
              let nextMonth = baseDate.dtb.addingMonth(1)?.value,
              let nextYear = baseDate.dtb.addingYear(1)?.value,
              let dayAdded = baseDate.dtb.adding(1, unit: .day)?.value,
              let hourAdded = baseDate.dtb.adding(5, unit: .hour)?.value,
              let minuteAdded = baseDate.dtb.adding(30, unit: .minute)?.value,
              let secondAdded = baseDate.dtb.adding(45, unit: .second)?.value else {
            XCTAssert(false)
            return
        }
        XCTAssertGreaterThan(addedDate.timeIntervalSince1970, baseDate.timeIntervalSince1970)
        XCTAssertEqual(nextDay.timeIntervalSince1970 - baseDate.timeIntervalSince1970, 24 * 3600, accuracy: 1)
        XCTAssertEqual(nextWeek.timeIntervalSince1970 - baseDate.timeIntervalSince1970, 7 * 24 * 3600, accuracy: 1)
        XCTAssertGreaterThan(nextMonth.timeIntervalSince1970, baseDate.timeIntervalSince1970)
        XCTAssertGreaterThan(nextYear.timeIntervalSince1970, baseDate.timeIntervalSince1970)
        XCTAssertEqual(dayAdded.timeIntervalSince1970 - baseDate.timeIntervalSince1970, 24 * 3600, accuracy: 1)
        XCTAssertEqual(hourAdded.timeIntervalSince1970 - baseDate.timeIntervalSince1970, 5 * 3600, accuracy: 1)
        XCTAssertEqual(minuteAdded.timeIntervalSince1970 - baseDate.timeIntervalSince1970, 30 * 60, accuracy: 1)
        XCTAssertEqual(secondAdded.timeIntervalSince1970 - baseDate.timeIntervalSince1970, 45, accuracy: 1)
    }

    func testDateComparison() throws {
        let date1 = Date(timeIntervalSince1970: 1577836800) // 2020-01-01
        let date2 = Date(timeIntervalSince1970: 1577836800 + 3600) // 1小时后

        // 时间差计算
        let delta = date1.dtb.delta(to: date2, .hour) ?? 0
        XCTAssertEqual(Double(delta), -1.0, accuracy: 0.1) // date1 比 date2 早1小时
        // 相同单位比较
        let sameDay = date1.dtb.same(to: date2, [.day])
        XCTAssertTrue(sameDay) // 同一天

        let sameHour = date1.dtb.same(to: date2, [.hour])
        XCTAssertFalse(sameHour) // 不同小时
    }

    func testDateSameComparison() throws {
        let date1 = Date(timeIntervalSince1970: 1577836800) // 2020-01-01 00:00:00
        let date2 = Date(timeIntervalSince1970: 1577836800 + 3600) // 2020-01-01 01:00:00
        let differentDay = Date(timeIntervalSince1970: 1577836800 + 24 * 3600) // 2020-01-02

        // 同一天比较
        XCTAssertTrue(date1.dtb.isSameDay(date2))
        XCTAssertFalse(date1.dtb.isSameDay(differentDay))

        // 同一年比较
        let sameYear = Date(timeIntervalSince1970: 1577836800 + 30 * 24 * 3600) // 一个月后
        let differentYear = Date(timeIntervalSince1970: 1609459200) // 2021-01-01

        XCTAssertTrue(date1.dtb.isSameYear(sameYear))
        XCTAssertFalse(date1.dtb.isSameYear(differentYear))

        // 同一月比较
        XCTAssertTrue(date1.dtb.isSameMonth(date2))
        XCTAssertFalse(date1.dtb.isSameMonth(differentYear))
    }

    // MARK: - Date Boundary Tests

    func testDateBoundaries() throws {
        let testDate = Date(timeIntervalSince1970: 1577923200) // 2020-01-01 24:00:00 UTC
        guard let startOfYear = testDate.dtb.startOfYear()?.value,
              let endOfYear = testDate.dtb.endOfYear()?.value,
              let startOfMonth = testDate.dtb.startOfMonth()?.value,
              let endOfMonth = testDate.dtb.endOfMonth()?.value,
              let startOfWeek = testDate.dtb.startOfWeek()?.value,
              let endOfWeek = testDate.dtb.endOfWeek()?.value,
              let startOfDay = testDate.dtb.startOfDay()?.value,
              let endOfDay = testDate.dtb.endOfDay()?.value else {
            XCTAssert(false)
            return
        }
        // 年的开始和结束
        XCTAssertLessThan(startOfYear.timeIntervalSince1970, testDate.timeIntervalSince1970)
        XCTAssertGreaterThan(endOfYear.timeIntervalSince1970, testDate.timeIntervalSince1970)
        // 月的开始和结束
        XCTAssertLessThanOrEqual(startOfMonth.timeIntervalSince1970, testDate.timeIntervalSince1970)
        XCTAssertGreaterThanOrEqual(endOfMonth.timeIntervalSince1970, testDate.timeIntervalSince1970)
        // 周的开始和结束
        XCTAssertLessThanOrEqual(startOfWeek.timeIntervalSince1970, testDate.timeIntervalSince1970)
        XCTAssertGreaterThanOrEqual(endOfWeek.timeIntervalSince1970, testDate.timeIntervalSince1970)
        // 天的开始和结束
        XCTAssertLessThanOrEqual(startOfDay.timeIntervalSince1970, testDate.timeIntervalSince1970)
        XCTAssertGreaterThanOrEqual(endOfDay.timeIntervalSince1970, testDate.timeIntervalSince1970)
    }

    // MARK: - Date Components Tests

    func testDateComponents() throws {
        let testDate = Date(timeIntervalSince1970: 1577836800) // 2020-01-01 00:00:00 UTC

        // 获取日期组件
        let components = testDate.dtb.dateComponents([.year, .month, .day])
        XCTAssertEqual(components.year, 2020)
        XCTAssertEqual(components.month, 1)
        XCTAssertEqual(components.day, 1)
    }

    func testDayMinutesCalculation() throws {
        // FIXME: 所有现有的时间实现都必须考虑时区
        
//        // 测试一天中的分钟计算
//        let midnight = Date(timeIntervalSince1970: 1577836800) // 2020-01-01 00:00:00 UTC
//        let midnightMinutes = midnight.dtb.dayMinutes()?.value
//        XCTAssertEqual(midnightMinutes, 0) // 午夜应该是0分钟
//
//        // 测试中午时间
//        let noon = Date(timeIntervalSince1970: 1577836800 + 12 * 3600) // 12:00 UTC
//        let noonMinutes = noon.dtb.dayMinutes()?.value
//        XCTAssertEqual(noonMinutes, 12 * 60) // 中午应该是720分钟
    }

    // MARK: - Time Duration Tests

    func testTimeDuration() throws {
//        let startTime = Date(timeIntervalSince1970: 0)
//        let duration: TimeInterval = 3661 // 1小时1分1秒
//
//        let durationString = startTime.dtb.toDuration(.text) ?? ""
//        XCTAssertNotNil(durationString)
//        XCTAssertTrue(durationString.contains("1") || durationString.contains("61")) // 应该包含小时或分钟信息
    }

    // MARK: - Dynamic Time Display Tests

    func testDynamicTimeDisplay() throws {
        // FIXME: 用例不对, barrier 参数必须覆盖整个时间轴
        
//        let baseDate = Date()
//
//        // 测试动态时间显示功能
//        let items = DTB.DateDynamicBarrierItem.self
//        // 负时间（过去）
//        let pastDate = Date(timeIntervalSinceNow: -3600) // 1小时前
//        let pastResult = pastDate.dtb.toDynamic([.negative("HH:mm")], baseOn: baseDate)
//        XCTAssertNotNil(pastResult)
//
//        // 一分钟内
//        let recentDate = Date(timeIntervalSinceNow: -30) // 30秒前
//        let oneMinuteResult = recentDate.dtb.toDynamic([.oneMinute()], baseOn: baseDate)
//        XCTAssertNotNil(oneMinuteResult)
//
//        // 一小时内
//        let hourAgoDate = Date(timeIntervalSinceNow: -1800) // 30分钟前
//        let oneHourResult = hourAgoDate.dtb.toDynamic([.oneHour()], baseOn: baseDate)
//        XCTAssertNotNil(oneHourResult)
//
//        // 今天
//        let todayDate = Date(timeIntervalSinceNow: -7200) // 2小时前（假设还是今天）
//        let todayResult = todayDate.dtb.toDynamic([.today()], baseOn: baseDate)
//        XCTAssertNotNil(todayResult)
//
//        // 昨天
//        let yesterdayDate = Date(timeIntervalSinceNow: -24 * 3600 - 3600) // 昨天的1小时前
//        let yesterdayResult = yesterdayDate.dtb.toDynamic([.yesterday()], baseOn: baseDate)
//        XCTAssertNotNil(yesterdayResult)
//
//        // 明天（未来时间）
//        let tomorrowDate = Date(timeIntervalSinceNow: 24 * 3600 + 3600) // 明天的1小时后
//        let tomorrowResult = tomorrowDate.dtb.toDynamic([.tomorrow()], baseOn: baseDate)
//        XCTAssertNotNil(tomorrowResult)
//
//        // 同年
//        let sameYearDate = Date(timeIntervalSinceNow: -30 * 24 * 3600) // 30天前
//        let sameYearResult = sameYearDate.dtb.toDynamic([.sameYear("MM-dd")], baseOn: baseDate)
//        XCTAssertNotNil(sameYearResult)
//
//        // 其他年份
//        let otherYearDate = Date(timeIntervalSinceNow: -400 * 24 * 3600) // 400天前（不同年）
//        let anotherResult = otherYearDate.dtb.toDynamic([.another()], baseOn: baseDate)
//        XCTAssertNotNil(anotherResult)
    }

    // MARK: - Edge Cases Tests

    func testDateEdgeCases() throws {
        // 极值日期测试
        let distantPast = Date.distantPast
        let distantFuture = Date.distantFuture

        // 这些应该不会崩溃
        let pastString = distantPast.dtb.toString()
        let futureString = distantFuture.dtb.toString()
        XCTAssertFalse(pastString.isEmpty)
        XCTAssertFalse(futureString.isEmpty)

        // 零时间戳
        let epoch = Date(timeIntervalSince1970: 0)
        XCTAssertEqual(epoch.dtb.s().value, 0)
        XCTAssertEqual(epoch.dtb.ms().value, 0)

        // 负时间戳
        let beforeEpoch = Date(timeIntervalSince1970: -1)
        XCTAssertEqual(beforeEpoch.dtb.s().value, -1)
        XCTAssertEqual(beforeEpoch.dtb.ms().value, -1000)
    }

    func testInvalidDateOperations() throws {
        let testDate = Date()

        // 无效格式字符串
        let invalidFormat = testDate.dtb.toString("")
        XCTAssertNotNil(invalidFormat) // 空格式应该返回某种默认值

        // 极大的时间偏移
        let extremeOffset = testDate.dtb.adding(Int.max, unit: .second)
        // 应该不会崩溃，可能返回 distantFuture 或原日期
        XCTAssertNotNil(extremeOffset)
    }
}

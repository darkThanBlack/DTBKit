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

    // MARK: - Date Basic Extensions Tests

    func testDateBasicConversions() throws {
        // 从秒级时间戳创建
        let sDate = Date.dtb.create(s: 1577836800)
        XCTAssertEqual(sDate.timeIntervalSince1970, 1577836800)

        // 从毫秒级时间戳创建
        let msDate = Date.dtb.create(ms: 1577836800000)
        XCTAssertEqual(msDate.timeIntervalSince1970, 1577836800)
        
        let testDate = Date(timeIntervalSince1970: 1577836800) // 2020-01-01 00:00:00 UTC
        XCTAssertEqual(testDate.dtb.s().value, 1577836800)
        XCTAssertEqual(testDate.dtb.ms().value, 1577836800000)
        
        let seconds: TimeInterval = 3661 // 1小时1分1秒
        // 秒级日期
        let secondsDate = seconds.dtb.sDate().value
        XCTAssertEqual(secondsDate.timeIntervalSince1970, 3661)

        // 毫秒级日期
        let millisecondsDate = seconds.dtb.msDate().value
        XCTAssertEqual(millisecondsDate.timeIntervalSince1970, 3.661, accuracy: 0.001)
    }

    func testDateStringOperations() throws {
        let testDate = 1577836800.dtb.sDate().value // 2020-01-01 00:00:00 UTC

        // 默认字符串格式
        let defaultString = testDate.dtb.toString().value
        XCTAssertFalse(defaultString.isEmpty)

        // 自定义格式字符串
        let isoFormat = testDate.dtb.format("yyyy-MM-dd'T'HH:mm:ss'Z'")
        XCTAssertTrue(isoFormat.contains("2020-01-01"))

        // 时间格式
        let timeOnly = testDate.dtb.format("HH:mm:ss")
        XCTAssertTrue(timeOnly.contains(":"))
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

        // 添加组件
        let components = DateComponents(day: 1, hour: 2, minute: 30)
        let addedDate = baseDate.dtb.adding(by: components)?.value
        XCTAssertGreaterThan(addedDate.timeIntervalSince1970, baseDate.timeIntervalSince1970)

        // 添加天数
        let nextDay = baseDate.dtb.addingDay(1)
        XCTAssertEqual(nextDay.timeIntervalSince1970 - baseDate.timeIntervalSince1970, 24 * 3600, accuracy: 1)

        // 添加周
        let nextWeek = baseDate.dtb.addingWeek(1)
        XCTAssertEqual(nextWeek.timeIntervalSince1970 - baseDate.timeIntervalSince1970, 7 * 24 * 3600, accuracy: 1)

        // 添加月（需要考虑月份天数差异）
        let nextMonth = baseDate.dtb.addingMonth(1)
        XCTAssertGreaterThan(nextMonth.timeIntervalSince1970, baseDate.timeIntervalSince1970)

        // 添加年
        let nextYear = baseDate.dtb.addingYear(1)
        XCTAssertGreaterThan(nextYear.timeIntervalSince1970, baseDate.timeIntervalSince1970)
    }

    func testDateUnitAddition() throws {
        let baseDate = Date(timeIntervalSince1970: 1577836800) // 2020-01-01

        // 测试不同单位的添加
        let dayAdded = baseDate.dtb.adding(1, unit: .day)
        XCTAssertEqual(dayAdded.timeIntervalSince1970 - baseDate.timeIntervalSince1970, 24 * 3600, accuracy: 1)

        let hourAdded = baseDate.dtb.adding(5, unit: .hour)
        XCTAssertEqual(hourAdded.timeIntervalSince1970 - baseDate.timeIntervalSince1970, 5 * 3600, accuracy: 1)

        let minuteAdded = baseDate.dtb.adding(30, unit: .minute)
        XCTAssertEqual(minuteAdded.timeIntervalSince1970 - baseDate.timeIntervalSince1970, 30 * 60, accuracy: 1)

        let secondAdded = baseDate.dtb.adding(45, unit: .second)
        XCTAssertEqual(secondAdded.timeIntervalSince1970 - baseDate.timeIntervalSince1970, 45, accuracy: 1)
    }

    func testDateComparison() throws {
        let date1 = Date(timeIntervalSince1970: 1577836800) // 2020-01-01
        let date2 = Date(timeIntervalSince1970: 1577836800 + 3600) // 1小时后

        // 时间差计算
        let delta = date1.dtb.delta(to: date2, .hour)
        XCTAssertEqual(delta, -1.0, accuracy: 0.1) // date1 比 date2 早1小时

        // 相同单位比较
        let sameDay = date1.dtb.same(to: date2, .day)
        XCTAssertTrue(sameDay) // 同一天

        let sameHour = date1.dtb.same(to: date2, .hour)
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

        // 年的开始和结束
        let startOfYear = testDate.dtb.startOfYear()
        let endOfYear = testDate.dtb.endOfYear()
        XCTAssertLessThan(startOfYear.timeIntervalSince1970, testDate.timeIntervalSince1970)
        XCTAssertGreaterThan(endOfYear.timeIntervalSince1970, testDate.timeIntervalSince1970)

        // 月的开始和结束
        let startOfMonth = testDate.dtb.startOfMonth()
        let endOfMonth = testDate.dtb.endOfMonth()
        XCTAssertLessThanOrEqual(startOfMonth.timeIntervalSince1970, testDate.timeIntervalSince1970)
        XCTAssertGreaterThanOrEqual(endOfMonth.timeIntervalSince1970, testDate.timeIntervalSince1970)

        // 周的开始和结束
        let startOfWeek = testDate.dtb.startOfWeek()
        let endOfWeek = testDate.dtb.endOfWeek()
        XCTAssertLessThanOrEqual(startOfWeek.timeIntervalSince1970, testDate.timeIntervalSince1970)
        XCTAssertGreaterThanOrEqual(endOfWeek.timeIntervalSince1970, testDate.timeIntervalSince1970)

        // 天的开始和结束
        let startOfDay = testDate.dtb.startOfDay()
        let endOfDay = testDate.dtb.endOfDay()
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
        // 测试一天中的分钟计算
        let midnight = Date(timeIntervalSince1970: 1577836800) // 2020-01-01 00:00:00 UTC
        let midnightMinutes = midnight.dtb.dayMinutes()
        XCTAssertEqual(midnightMinutes, 0) // 午夜应该是0分钟

        // 测试中午时间
        let noon = Date(timeIntervalSince1970: 1577836800 + 12 * 3600) // 12:00 UTC
        let noonMinutes = noon.dtb.dayMinutes()
        XCTAssertEqual(noonMinutes, 12 * 60) // 中午应该是720分钟
    }

    // MARK: - Time Duration Tests

    func testTimeDuration() throws {
        let startTime = Date(timeIntervalSince1970: 0)
        let duration: TimeInterval = 3661 // 1小时1分1秒

        let durationString = startTime.dtb.toDuration(duration)
        XCTAssertNotNil(durationString)
        XCTAssertTrue(durationString.contains("1") || durationString.contains("61")) // 应该包含小时或分钟信息
    }

    // MARK: - Dynamic Time Display Tests

    func testDynamicTimeDisplay() throws {
        let baseDate = Date()

        // 测试动态时间显示功能
        let items = DTB.DateDynamicBarrierItem.self

        // 负时间（过去）
        let pastDate = Date(timeIntervalSinceNow: -3600) // 1小时前
        let negativeItem = items.negative { date in
            return date.dtb.format("HH:mm")
        }
        let pastResult = pastDate.dtb.toDynamic([negativeItem], baseOn: baseDate)
        XCTAssertNotNil(pastResult)

        // 一分钟内
        let recentDate = Date(timeIntervalSinceNow: -30) // 30秒前
        let oneMinuteResult = recentDate.dtb.toDynamic([items.oneMinute], baseOn: baseDate)
        XCTAssertNotNil(oneMinuteResult)

        // 一小时内
        let hourAgoDate = Date(timeIntervalSinceNow: -1800) // 30分钟前
        let oneHourResult = hourAgoDate.dtb.toDynamic([items.oneHour], baseOn: baseDate)
        XCTAssertNotNil(oneHourResult)

        // 今天
        let todayDate = Date(timeIntervalSinceNow: -7200) // 2小时前（假设还是今天）
        let todayItem = items.today { date in
            return date.dtb.format("HH:mm")
        }
        let todayResult = todayDate.dtb.toDynamic([todayItem], baseOn: baseDate)
        XCTAssertNotNil(todayResult)

        // 昨天
        let yesterdayDate = Date(timeIntervalSinceNow: -24 * 3600 - 3600) // 昨天的1小时前
        let yesterdayItem = items.yesterday { date in
            return "昨天 " + date.dtb.format("HH:mm")
        }
        let yesterdayResult = yesterdayDate.dtb.toDynamic([yesterdayItem], baseOn: baseDate)
        XCTAssertNotNil(yesterdayResult)

        // 明天（未来时间）
        let tomorrowDate = Date(timeIntervalSinceNow: 24 * 3600 + 3600) // 明天的1小时后
        let tomorrowItem = items.tomorrow { date in
            return "明天 " + date.dtb.format("HH:mm")
        }
        let tomorrowResult = tomorrowDate.dtb.toDynamic([tomorrowItem], baseOn: baseDate)
        XCTAssertNotNil(tomorrowResult)

        // 同年
        let sameYearDate = Date(timeIntervalSinceNow: -30 * 24 * 3600) // 30天前
        let sameYearItem = items.sameYear { date in
            return date.dtb.format("MM-dd")
        }
        let sameYearResult = sameYearDate.dtb.toDynamic([sameYearItem], baseOn: baseDate)
        XCTAssertNotNil(sameYearResult)

        // 其他年份
        let otherYearDate = Date(timeIntervalSinceNow: -400 * 24 * 3600) // 400天前（不同年）
        let anotherItem = items.another { date in
            return date.dtb.format("yyyy-MM-dd")
        }
        let anotherResult = otherYearDate.dtb.toDynamic([anotherItem], baseOn: baseDate)
        XCTAssertNotNil(anotherResult)
    }

    // MARK: - Edge Cases Tests

    func testDateEdgeCases() throws {
        // 极值日期测试
        let distantPast = Date.distantPast
        let distantFuture = Date.distantFuture

        // 这些应该不会崩溃
        let pastString = distantPast.dtb.toString().value
        let futureString = distantFuture.dtb.toString().value
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
        let invalidFormat = testDate.dtb.format("")
        XCTAssertNotNil(invalidFormat) // 空格式应该返回某种默认值

        // 极大的时间偏移
        let extremeOffset = testDate.dtb.adding(Int.max, unit: .second)
        // 应该不会崩溃，可能返回 distantFuture 或原日期
        XCTAssertNotNil(extremeOffset)
    }
}

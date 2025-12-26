//
//  Int+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/8/29
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import Foundation

// FIXME: 非标格式
extension Wrapper where Base: FixedWidthInteger & SignedInteger {

    
    /// 分钟数转 "HH:mm" 形式, "00:00"
    @inline(__always)
    public func minutesString() -> String {
        return String(format: "%02d:%02d", Int(me) / 60, Int(me) % 60)
    }
    
    /// 将数字转换为星期名称
    ///
    /// - Parameter type: 是否使用 ISO 8601 标准 (数字1 对应周一还是周日)
    /// - Returns: 本地化的星期名称
    @inline(__always)
    public func weekDayString(_ type: DTB.WeekdayTypes = .iso) -> String? {
        switch type {
        case .iso:
            return [
                1: "周一", 2: "周二", 3: "周三", 4: "周四", 5: "周五", 6: "周六", 7: "周日"
            ][me]
        case .gregorian:
            return [
                1: "周日", 2: "周一", 3: "周二", 4: "周三", 5: "周四", 6: "周五", 7: "周六"
            ][me]
        }
    }
}

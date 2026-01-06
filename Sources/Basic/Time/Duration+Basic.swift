//
//  Duration+Basic.swift
//  DTBKit_Basic
//
//  Created by moonShadow on 2026/1/6
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension Wrapper where Base: FixedWidthInteger & SignedInteger {
    
    /// 根据毫秒时间戳转换为可读的时长字符串
    public func toDuration(_ type: DTB.DateDurationFormatTypes) -> String? {
        let seconds = me / 1000
        let minutes = seconds / 60
        let hours = minutes / 60
        
        switch type {
        case .text:
            if hours > 0 {
                return "\(hours)小时\(minutes % 60)分"
            } else if minutes > 0 {
                return "\(minutes % 60)分\(seconds % 60)秒"
            } else {
                return "\(seconds % 60)秒"
            }
        case .symbol:
            if minutes > 0 {
                return "\(minutes)\'\(seconds % 60)\""
            } else {
                return "\(seconds % 60)\""
            }
        }
    }

}

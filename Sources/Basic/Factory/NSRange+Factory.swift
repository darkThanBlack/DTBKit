//
//  NSRange+Factory.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/11/6
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB.StaticWrapper where T == NSRange {
    
    /// location | length
    @inline(__always)
    public func callAsFunction(_ location: Int, _ length: Int) -> T {
        return NSRange(location: location, length: length)
    }
}

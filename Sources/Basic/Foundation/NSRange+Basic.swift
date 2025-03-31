//
//  NSRange+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/11/6
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
extension Wrapper where Base == NSRange {
    
    /// location == NSNotFound or length == 0
    @inline(__always)
    public func isEmpty() -> Bool {
        return (me.location == NSNotFound) || (me.length == 0)
    }
}

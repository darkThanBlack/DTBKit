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
extension DTBKitWrapper where Base == NSRange {
    
    /// location == NSNotFound or length == 0
    public var isEmpty: Bool {
        return (me.location == NSNotFound) || (me.length == 0)
    }
}

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

// Range location and length will always >= 0.0 and not NSNotFound semantically.

///
extension DTBKitWrapper where Base == NSRange {
    
    ///
    public var isEmpty: Bool {
        return (me.location == NSNotFound) || (me.length == 0)
    }
}

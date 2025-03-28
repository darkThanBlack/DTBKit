//
//  NSString+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/11/7
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

///
extension Wrapper where Base: NSString {
    
    @inline(__always)
    @discardableResult
    public func range(of searchString: String) -> Wrapper<NSRange> {
        return me.range(of: searchString).dtb
    }
}

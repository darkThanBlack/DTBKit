//
//  String+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/10/8
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTBKitWrapper where Base: NSString {
    
    @discardableResult
    public func range(of searchString: String) -> DTBKitWrapper<NSRange> {
        return me.range(of: searchString).dtb
    }
}

extension DTBKitWrapper where Base == String {
    
    ///
    public var count: Int {
        return me.utf16.count
    }
    
    ///
    public var ns: DTBKitWrapper<NSString> {
        return NSString(string: me).dtb
    }
    
    ///
    public var nsAttr: DTBKitWrapper<NSMutableAttributedString> {
        return NSMutableAttributedString(string: me).dtb
    }
    
    ///
    public func has(nsRange: NSRange) -> Bool {
        if nsRange.location < ns.value.length,
           nsRange.location + nsRange.length < ns.value.length {
            return true
        }
        return false
    }
    
    
    
}

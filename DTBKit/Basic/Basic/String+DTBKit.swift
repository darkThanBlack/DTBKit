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

/// NSString
extension DTBKitWrapper where Base == String {
    
    ///
    public var ns: DTBKitWrapper<NSString> {
        return NSString(string: me).dtb
    }
    
    /// Adapter for NSString.length.
    ///
    /// 使用 NS 系列 API 时必须注意 String 和 NSString 的根本不同；
    /// 如果对此没有了解，建议全部使用 NSString 来处理。
    ///
    /// ```
    ///     let a = "".utf16.count
    ///     let b = NSString(string: "").length
    ///     // (a == b) == true
    /// ```
    public var nsCount: Int {
        return me.utf16.count
    }
    
    ///
    public var nsAttr: DTBKitWrapper<NSMutableAttributedString> {
        return NSMutableAttributedString(string: me).dtb
    }
    
    ///
    public func has(nsRange: NSRange) -> Bool {
        if nsRange.dtb.isEmpty == false,
           nsRange.location < ns.value.length,
           nsRange.location + nsRange.length < ns.value.length {
            return true
        }
        return false
    }
}

/// Regular
extension DTBKitWrapper where Base == String {
    
    ///
    public func isMatches(_ exp: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", exp).evaluate(with: me)
    }
    
    ///
    public func isRegular(_ value: DTBKitStringRegulars) -> Bool {
        return isMatches(value.exp)
    }
}


extension DTBKitWrapper where Base == String {
    
    
    
}

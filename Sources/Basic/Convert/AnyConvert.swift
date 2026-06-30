//
//  AnyConvert.swift
//  DTBKit
//
//  Created by moonShadow on 2026/6/30
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// Let's guess what's shit inside.
    public struct AnyConvert {
        
        public func `int64`(_ value: Any?) -> Int64? {
            if let v = value as? (any (FixedWidthInteger & SignedInteger)) { return Int64(v) }
            if let v = value as? (any BinaryFloatingPoint) { return Int64(v) }
            if let v = value as? String { return Int64(v) }
            return nil
        }
        
        public func `double`(_ value: Any?) -> Double? {
            if let v = value as? (any BinaryFloatingPoint) { return Double(v) }
            if let v = value as? (any (FixedWidthInteger & SignedInteger)) { return Double(v) }
            if let v = value as? String { return Double(v) }
            return nil
        }
        
    }
    
}

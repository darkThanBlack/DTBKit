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


import Foundation
import CoreGraphics

extension DTB {
    
    /// Let's guess what's shit inside.
    public struct AnyConvert {
        
        public func `int64`(_ value: Any?) -> Int64? {
            if let v = value as? Int64 { return v }
            if let v = value as? (any (FixedWidthInteger & SignedInteger)) { return Int64(exactly: v) }
            if let v = value as? (any BinaryFloatingPoint) {
                return Int64(exactly: Double(v).rounded(.towardZero))
            }
            if let v = value as? String { return Int64(v) }
            return nil
        }
        
        public func `int`(_ value: Any?) -> Int? {
            if let v = value as? Int { return v }
            if let v = int64(value) { return Int(v) }
            return nil
        }
        
        public func `double`(_ value: Any?) -> Double? {
            if let v = value as? Double { return v.isFinite ? v : nil }
            if let v = value as? (any BinaryFloatingPoint) {
                let d = Double(v)
                return d.isFinite ? d : nil
            }
            if let v = value as? (any (FixedWidthInteger & SignedInteger)) { return Double(v) }
            if let v = value as? String, let d = Double(v), d.isFinite { return d }
            return nil
        }
        
        public func `cgFloat`(_ value: Any?) -> CGFloat? {
            if let v = value as? CGFloat { return v.isFinite ? v : nil }
            if let v = double(value) { return CGFloat(v) }
            return nil
        }
        
    }
    
}

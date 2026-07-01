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
        
        public func `int`(_ value: Any?) -> Int? {
            if let v = int64(value) { return Int(v) }
            return nil
        }
        
        public func `double`(_ value: Any?) -> Double? {
            if let v = value as? (any BinaryFloatingPoint) { return Double(v) }
            if let v = value as? (any (FixedWidthInteger & SignedInteger)) { return Double(v) }
            if let v = value as? String { return Double(v) }
            return nil
        }
        
        public func `cgFloat`(_ value: Any?) -> CGFloat? {
            if let v = double(value) { return CGFloat(v) }
            return nil
        }
        
        public func `uiEdgeInsets`(_ value: Any?) -> UIEdgeInsets? {
            guard let dict = value as? [String: Any] else { return nil }
            return UIEdgeInsets(
                top: DTB.any.double(dict["top"]) ?? 0,
                left: DTB.any.double(dict["left"]) ?? 0,
                bottom: DTB.any.double(dict["bottom"]) ?? 0,
                right: DTB.any.double(dict["right"]) ?? 0
            )
        }
        
        public func `cgSize`(_ value: Any?) -> CGSize? {
            guard let dict = value as? [String: Any] else { return nil }
            return CGSize(
                width: DTB.any.double(dict["width"]) ?? 0,
                height: DTB.any.double(dict["height"]) ?? 0
            )
        }
        
        public func `cgVector`(_ value: Any?) -> CGVector? {
            guard let dict = value as? [String: Any] else { return nil }
            return CGVector(
                dx: DTB.any.double(dict["dx"]) ?? 0,
                dy: DTB.any.double(dict["dy"]) ?? 0
            )
        }

    }
    
}

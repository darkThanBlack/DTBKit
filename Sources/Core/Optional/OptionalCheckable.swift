//
//  OptionalCheckable.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import Foundation
import CoreGraphics

extension DTB {
    
    ///
    public protocol OptionalCheckable {
        
        static func dtb_defaultValue() -> Self
        
        func dtb_isInvalid() -> Bool
        
        func dtb_isValid() -> Bool
    }
}

public extension DTB.OptionalCheckable {
    
    func dtb_isValid() -> Bool { return !dtb_isInvalid() }
}

// MARK: -

extension String: DTB.OptionalCheckable {
    
    @inline(__always)
    public static func dtb_defaultValue() -> Self { return "" }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return isEmpty }
}

extension Dictionary: DTB.OptionalCheckable {
    
    @inline(__always)
    public static func dtb_defaultValue() -> Self { return [:] }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return isEmpty }
}

extension Array: DTB.OptionalCheckable {
    
    @inline(__always)
    public static func dtb_defaultValue() -> Self { return [] }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return isEmpty }
}

extension Set: DTB.OptionalCheckable {
    
    @inline(__always)
    public static func dtb_defaultValue() -> Self { return [] }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool { return isEmpty }
}

// MARK: -

extension CGSize: DTB.OptionalCheckable {

    public static func dtb_defaultValue() -> Self {
        return .zero
    }

    public func dtb_isInvalid() -> Bool {
        return (width <= 0) || (height <= 0)
    }
}

extension CGRect: DTB.OptionalCheckable {

    public static func dtb_defaultValue() -> Self {
        return .zero
    }

    public func dtb_isInvalid() -> Bool {
        return isEmpty
    }
}

extension NSRange: DTB.OptionalCheckable {

    public static func dtb_defaultValue() -> Self {
        return NSRange(location: 0, length: 0)
    }

    public func dtb_isInvalid() -> Bool {
        return (location == NSNotFound) || (length < 0)
    }
}

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

extension DTB {
    
    ///
    public protocol OptionalCheckable {
        
        static func dtb_defaultValue() -> Self
        
        func dtb_isInvalid() -> Bool
    }
}

public extension DTB.OptionalCheckable {
    
    @inline(__always)
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

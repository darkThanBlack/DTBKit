//
//  EmptyManager.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/25
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    public protocol EmptyCheckable {
        
        static func emptyValue() -> Self
        
        func isEmpty() -> Bool
    }
    
    public struct EmptyChecker {
        
        @inline(__always)
        public func `is`<E: DTB.EmptyCheckable>(_ value: E?) -> Bool {
            return value?.isEmpty() ?? true
        }
        
        @inline(__always)
        public func `not`<E: DTB.EmptyCheckable>(_ value: E?) -> Bool {
            return value?.isEmpty() == false
        }
        
        @inline(__always)
        public func `or`<E: DTB.EmptyCheckable>(_ value: E?) -> E {
            switch value {
            case .none:
                return E.emptyValue()
            case .some(let wrapped):
                return wrapped.isEmpty() ? E.emptyValue() : wrapped
            }
        }
    }
    
}

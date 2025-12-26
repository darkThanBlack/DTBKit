//
//  OptionalChecker.swift
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
        
        static func dtb_emptyValue() -> Self
        
        func dtb_isEmpty() -> Bool
    }
    
    public protocol NumberCheckable {
        
        static func dtb_zeroValue() -> Self
        
        func dtb_isZero() -> Bool
        
        func dtb_isFinite() -> Bool
        
        func dtb_isInvalid() -> Bool
        
        func dtb_isPositive() -> Bool
        
        func dtb_isNegative() -> Bool
    }
    
    /// Check nil or Empty / Zero / ...
    public struct OptionalChecker {
        
        // MARK: - Object, empty
        
        /// isEmpty: return true when value is nil / empty.
        @inline(__always)
        public func isEmpty<E>(_ value: E?) -> Bool where E: DTB.EmptyCheckable {
            return value?.dtb_isEmpty() ?? true
        }
        
        /// isNotEmpty: return false when value is nil / empty.
        @inline(__always)
        public func isNotEmpty<E>(_ value: E?) -> Bool where E: DTB.EmptyCheckable {
            return !self.isEmpty(value)
        }
        
        /// orEmpty: return ``dtb_emptyValue`` when value is nil.
        @inline(__always)
        public func `or`<E>(_ value: E?) -> E where E: DTB.EmptyCheckable {
            return self.isEmpty(value) ? E.dtb_emptyValue() : value!
        }
        
        /// orEmpty: return ``def`` when value is nil.
        @inline(__always)
        public func `or`<E>(_ value: E?, def: E) -> E where E: DTB.EmptyCheckable {
            return self.isEmpty(value) ? def : value!
        }
        
        // MARK: - Number, nan / infinite
        
        /// isEmpty: return true when value is nil / empty.
        @inline(__always)
        public func isEmpty<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return value?.dtb_isInvalid() ?? true
        }
        
        /// isNotEmpty: return false when value is nil / empty.
        @inline(__always)
        public func isNotEmpty<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return !self.isEmpty(value)
        }
        
        // MARK: - Number, zero
        
        /// isZeroOrEmpty: return true when value is nil / nan / infinite / zero.
        @inline(__always)
        public func isZeroOr<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() ?? true) || (value?.dtb_isZero() ?? true)
        }
        
        /// isNotZeroOrEmpty: return false when value is nil / nan / infinite / zero.
        @inline(__always)
        public func isNotZeroOr<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return !isZeroOr(value)
        }
        
        /// orZero: return ``dtb_zeroValue`` when value is nil / nan / infinite.
        @inline(__always)
        public func orZero<E>(_ value: E?) -> E where E: DTB.NumberCheckable {
            return self.isZeroOr(value) ? E.dtb_zeroValue() : value!
        }
        
        // MARK: - Number, positive / negative
        
        
    }
    
}

// MARK: - 放弃对 Optional 的扩展，因为多重可选链最后一步解析不到，除非用括号指定优先级，这样意义不大

//extension DTB {
//
//    func tttttttttttttt() {
//        // Optional(123)
//
//        let a: Double? = 123.233
//        let b: Bool? = a?.dtb.isEmpty()
//        let c: Bool = (a?.dtb).isEmpty()
//
//        let d: String? = "123"
//        guard (d?.dtb).isEmpty() else {
//            return
//        }
//
//    }
//}
//
//extension Optional where Wrapped == Wrapper<String> {
//
//    @inline(__always)
//    public func isEmpty() -> Bool {
//        return self?.isEmpty() ?? true
//    }
//
//    @inline(__always)
//    public func orEmpty() -> String {
//        return self?.me ?? ""
//    }
//
//}
//
//extension Optional where Wrapped == Wrapper<Double> {
//
//    @inline(__always)
//    public func isEmpty() -> Bool {
//        return self?.me.isFinite != true
//    }
//
//    @inline(__always)
//    public func isZeroOrEmpty() -> Bool {
//        return self?.me.isZero == true ? true : isEmpty()
//    }
//
//}

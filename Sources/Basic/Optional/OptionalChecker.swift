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
    
    /// For object
    public protocol EmptyCheckable {
        
        static func dtb_emptyValue() -> Self
        
        func dtb_isEmpty() -> Bool
    }
    
    /// For number
    public protocol NumberEmptyCheckable: EmptyCheckable {
        
        /// 0
        static func dtb_zeroValue() -> Self
        
        /// != .NaN && != .infinite; Int will always return true.
        func dtb_isFinite() -> Bool
        
        /// == 0
        func dtb_isZero() -> Bool
        
        /// > 0
        func dtb_isPositive() -> Bool
        
        /// < 0
        func dtb_isNegative() -> Bool
    }
    
    /// - Unbox for Optional / Empty / Zero
    public struct OptionalChecker {
        
        // MARK: - Object, empty
        
        /// orEmpty
        @inline(__always)
        public func `or`<E>(_ value: E?, def: E? = nil) -> E where E: DTB.EmptyCheckable {
            return orEmpty(value, def: def)
        }
        
        /// return TRUE when value is nil / empty.
        @inline(__always)
        public func isEmpty<E>(_ value: E?) -> Bool where E: DTB.EmptyCheckable {
            return value?.dtb_isEmpty() ?? true
        }
        
        /// return TRUE when value is NOT nil / empty.
        @inline(__always)
        public func isNotEmpty<E>(_ value: E?) -> Bool where E: DTB.EmptyCheckable {
            return !isEmpty(value)
        }
        
        /// return ``def ?? dtb_emptyValue`` when value is nil / empty.
        @inline(__always)
        public func orEmpty<E>(_ value: E?, def: E? = nil) -> E where E: DTB.EmptyCheckable {
            return (isEmpty(value) ? def : value) ?? E.dtb_emptyValue()
        }
        
        // MARK: - Number, zero
        
        /// return true when value is nil / nan / infinite / zero.
        @inline(__always)
        public func isEmptyOrZero<E>(_ value: E?) -> Bool where E: DTB.NumberEmptyCheckable {
            return !isNotEmptyOrZero(value)
        }
        
        /// return false when value is nil / nan / infinite / zero.
        @inline(__always)
        public func isNotEmptyOrZero<E>(_ value: E?) -> Bool where E: DTB.NumberEmptyCheckable {
            return (value?.dtb_isFinite() == true) && (value?.dtb_isZero() == false)
        }
        
        /// return ``dtb_zeroValue`` when value is nil / nan / infinite.
        @inline(__always)
        public func orZero<E>(_ value: E?) -> E where E: DTB.NumberEmptyCheckable {
            return orEmpty(value)
        }
        
        // MARK: - Number, positive / negative
        
        /// isPositive: return true when value is not invalid and > 0
        @inline(__always)
        public func isPositive<E>(_ value: E?) -> Bool where E: DTB.NumberEmptyCheckable {
            return isNotEmptyOrZero(value) && (value?.dtb_isPositive() == true)
        }
        
        /// isNegative: return true when value is not invalid and < 0
        @inline(__always)
        public func isNegative<E>(_ value: E?) -> Bool where E: DTB.NumberEmptyCheckable {
            return isNotEmptyOrZero(value) && (value?.dtb_isNegative() == true)
        }
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
//    public func isEmptyOrZero() -> Bool {
//        return self?.me.isZero == true ? true : isEmpty()
//    }
//
//}

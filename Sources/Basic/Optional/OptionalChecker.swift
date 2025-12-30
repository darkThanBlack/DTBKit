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
    public protocol NumberCheckable {
        
        /// 0
        static func dtb_zeroValue() -> Self
        
        /// !isFinite
        ///
        /// - Note: Int will always return false.
        func dtb_isInvalid() -> Bool
        
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
        
        /// isEmpty
        @inline(__always)
        public func `e`<E>(_ value: E?) -> Bool where E: DTB.EmptyCheckable {
            return isEmpty(value)
        }
        
        /// isNotEmpty
        @inline(__always)
        public func `ne`<E>(_ value: E?) -> Bool where E: DTB.EmptyCheckable {
            return isNotEmpty(value)
        }
        
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
            return value?.dtb_isEmpty() == false
        }
        
        /// return ``def ?? dtb_emptyValue`` when value is nil / empty.
        @inline(__always)
        public func orEmpty<E>(_ value: E?, def: E? = nil) -> E where E: DTB.EmptyCheckable {
            return (value?.dtb_isEmpty() ?? true) ? (def ?? E.dtb_emptyValue()) : value!
        }
        
        // MARK: - Number, nan / infinite
        
        /// isEmpty
        @inline(__always)
        public func `e`<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return isEmpty(value)
        }
        
        /// isNotEmpty
        @inline(__always)
        public func `ne`<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return isNotEmpty(value)
        }
        
        /// orEmpty
        @inline(__always)
        public func `or`<E>(_ value: E?, def: E? = nil) -> E where E: DTB.NumberCheckable {
            return orEmpty(value, def: def)
        }
        
        /// return TRUE when value is nil / nan / infinite.
        @inline(__always)
        public func isEmpty<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return value?.dtb_isInvalid() ?? true
        }
        
        /// return TRUE when value is NOT nil / nan / infinite.
        @inline(__always)
        public func isNotEmpty<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return value?.dtb_isInvalid() == false
        }
        
        /// return ``def ?? dtb_zeroValue`` when value is nil / nan / infinite.
        @inline(__always)
        public func orEmpty<E>(_ value: E?, def: E? = nil) -> E where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() ?? true) ? (def ?? E.dtb_zeroValue()) : value!
        }
        
        // MARK: - Number, zero
        
        /// isEmptyOrZero
        @inline(__always)
        public func `ez`<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return isEmptyOrZero(value)
        }
        
        /// isNotEmptyOrZero
        @inline(__always)
        public func `nez`<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return isNotEmptyOrZero(value)
        }
        
        /// return true when value is nil / nan / infinite / zero.
        @inline(__always)
        public func isEmptyOrZero<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() ?? true) || (value?.dtb_isZero() ?? true)
        }
        
        /// return false when value is nil / nan / infinite / zero.
        @inline(__always)
        public func isNotEmptyOrZero<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() == false) && (value?.dtb_isZero() == false)
        }
        
        /// return ``dtb_zeroValue`` when value is nil / nan / infinite.
        @inline(__always)
        public func orZero<E>(_ value: E?) -> E where E: DTB.NumberCheckable {
            return orEmpty(value)
        }
        
        // MARK: - Number, positive / negative
        
        /// isPositive: return true when value is not invalid and > 0
        @inline(__always)
        public func `pos`<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return isPositive(value)
        }
        
        /// isNegative: return true when value is not invalid and < 0
        @inline(__always)
        public func `neg`<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return isNegative(value)
        }
        
        /// isPositive: return true when value is not invalid and > 0
        @inline(__always)
        public func isPositive<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() == false) && (value?.dtb_isPositive() == true)
        }
        
        /// isNegative: return true when value is not invalid and < 0
        @inline(__always)
        public func isNegative<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() == false) && (value?.dtb_isNegative() == true)
        }
        
        /// orPositive: return `def ?? dtb_zeroValue` when value is nil / invalid / non-positive
        @inline(__always)
        public func orPositive<E>(_ value: E?, def: E? = nil) -> E where E: DTB.NumberCheckable {
            return isPositive(value) ? value! : (def ?? E.dtb_zeroValue())
        }
        
        /// orNegative: return `def ?? dtb_zeroValue` when value is nil / invalid / non-negative
        @inline(__always)
        public func orNegative<E>(_ value: E?, def: E? = nil) -> E where E: DTB.NumberCheckable {
            return isNegative(value) ? value! : (def ?? E.dtb_zeroValue())
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

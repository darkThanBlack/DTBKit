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
        
        /// 0
        static func dtb_zeroValue() -> Self
        
        /// !isFinite
        func dtb_isInvalid() -> Bool
        
        /// == 0
        func dtb_isZero() -> Bool
        
        /// > 0
        func dtb_isPositive() -> Bool
        
        /// < 0
        func dtb_isNegative() -> Bool
    }
    
    /// Check / Unbox for Optional / Empty / Zero / ...
    public struct OptionalChecker {
        
        // MARK: - Object, empty
        
        /// isEmpty
        @inline(__always)
        public func `e`<E>(_ value: E?) -> Bool where E: DTB.EmptyCheckable {
            return value?.dtb_isEmpty() ?? true
        }
        
        /// isNotEmpty
        @inline(__always)
        public func `ne`<E>(_ value: E?) -> Bool where E: DTB.EmptyCheckable {
            return value?.dtb_isEmpty() == false
        }
        
        /// orEmpty
        @inline(__always)
        public func `or`<E>(_ value: E?) -> E where E: DTB.EmptyCheckable {
            return (value?.dtb_isEmpty() ?? true) ? E.dtb_emptyValue() : value!
        }
        
        /// orEmpty
        @inline(__always)
        public func `or`<E>(_ value: E?, def: E) -> E where E: DTB.EmptyCheckable {
            return (value?.dtb_isEmpty() ?? true) ? def : value!
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
        
        /// return ``dtb_emptyValue`` when value is nil / empty.
        @inline(__always)
        public func orEmpty<E>(_ value: E?) -> E where E: DTB.EmptyCheckable {
            return (value?.dtb_isEmpty() ?? true) ? E.dtb_emptyValue() : value!
        }
        
        /// return ``def`` when value is nil / empty.
        @inline(__always)
        public func orEmpty<E>(_ value: E?, def: E) -> E where E: DTB.EmptyCheckable {
            return (value?.dtb_isEmpty() ?? true) ? def : value!
        }
        
        // MARK: - Number, empty == invalid == nan / infinite
        
        /// isEmpty
        @inline(__always)
        public func `e`<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return value?.dtb_isInvalid() ?? true
        }
        
        /// isNotEmpty
        @inline(__always)
        public func `ne`<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return value?.dtb_isInvalid() == false
        }
        
        /// orEmpty
        @inline(__always)
        public func `or`<E>(_ value: E?) -> E where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() ?? true) ? E.dtb_zeroValue() : value!
        }
        
        /// orEmpty
        @inline(__always)
        public func `or`<E>(_ value: E?, def: E) -> E where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() ?? true) ? def : value!
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
        
        /// orZero
        @inline(__always)
        public func orEmpty<E>(_ value: E?) -> E where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() ?? true) ? E.dtb_zeroValue() : value!
        }
        
        /// return ``def`` when value is nil / nan / infinite.
        @inline(__always)
        public func orEmpty<E>(_ value: E?, def: E) -> E where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() ?? true) ? def : value!
        }
        
        // MARK: - Number, zero
        
        /// isEmptyOrZero
        @inline(__always)
        public func `ez`<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() ?? true) || (value?.dtb_isZero() ?? true)
        }
        
        /// isNotEmptyOrZero
        @inline(__always)
        public func `nez`<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() == false) && (value?.dtb_isZero() == false)
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
            return self.isEmpty(value) ? E.dtb_zeroValue() : value!
        }
        
        // MARK: - Number, positive / negative
        
        /// isPositive: return true when value is not invalid and > 0
        @inline(__always)
        public func pos<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() == false) && (value?.dtb_isPositive() == true)
        }
        
        /// isPositive: return true when value is not invalid and > 0
        @inline(__always)
        public func isPositive<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() == false) && (value?.dtb_isPositive() == true)
        }

        /// isNonPositive: return true when value is invalid or <= 0
        @inline(__always)
        public func isNonPositive<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() ?? true) || !(value?.dtb_isPositive() == true)
        }

        /// isNegative: return true when value is not invalid and < 0
        @inline(__always)
        public func isNegative<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() == false) && (value?.dtb_isNegative() == true)
        }

        /// isNonNegative: return true when value is invalid or >= 0
        @inline(__always)
        public func isNonNegative<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return (value?.dtb_isInvalid() ?? true) || !(value?.dtb_isNegative() == true)
        }

        /// orPositive: return `dtb_zeroValue` when value is nil / invalid / non-positive
        @inline(__always)
        public func orPositive<E>(_ value: E?) -> E where E: DTB.NumberCheckable {
            return isPositive(value) ? value! : E.dtb_zeroValue()
        }

        /// orNegative: return `dtb_zeroValue` when value is nil / invalid / non-negative
        @inline(__always)
        public func orNegative<E>(_ value: E?) -> E where E: DTB.NumberCheckable {
            return isNegative(value) ? value! : E.dtb_zeroValue()
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

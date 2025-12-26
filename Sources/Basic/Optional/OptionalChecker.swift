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
        
        static func dtb_defaultEmptyValue() -> Self
        
        func dtb_isEmpty() -> Bool
    }
    
    public protocol ZeroCheckable: EmptyCheckable {
        
        func dtb_isZero() -> Bool
    }
    
    public struct OptionalChecker {
        
        @inline(__always)
        public func `is`<E: DTB.EmptyCheckable>(_ value: E?) -> Bool {
            return value?.dtb_isEmpty() ?? true
        }
        
        @inline(__always)
        public func `isNot`<E: DTB.EmptyCheckable>(_ value: E?) -> Bool {
            return value?.dtb_isEmpty() == false
        }
        
        @inline(__always)
        public func `or`<E: DTB.EmptyCheckable>(_ value: E?) -> E {
            return value?.dtb_isEmpty() == false ? value! : E.dtb_defaultEmptyValue()
        }
        
        @inline(__always)
        public func `or`<E: DTB.EmptyCheckable>(_ value: E?, def: E) -> E {
            return value?.dtb_isEmpty() == false ? value! : def
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
//    public func isZeroOrEmpty() -> Bool {
//        return self?.me.isZero == true ? true : isEmpty()
//    }
//
//}

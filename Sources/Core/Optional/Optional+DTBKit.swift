//
//  Optional+DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2025/12/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import Foundation

// MARK: - 链式形态
//
// `a?.dtb.or()` 这类「可选链 + DTB.Wrapper」无法实现：`?` 之后整条链恒为 Optional，
// 成员查找发生在 `DTB.Wrapper` 上，落不到 `Optional` 扩展；要命中必须写成 `(a?.dtb).or()`。
//
// 因此链式形态只提供给「已成型的 Optional」，并统一加 `dtb_` 前缀避免污染宿主命名空间：
//     let a: String? = nil
//     a.dtb_or()                  // ""
//     DTB.any.int64(x).dtb_or()   // Int64

extension Optional where Wrapped: DTB.OptionalCheckable {
    
    @inline(__always)
    public func dtb_or(_ def: Wrapped? = nil) -> Wrapped {
        guard let value = self, value.dtb_isInvalid() == false else {
            return def ?? Wrapped.dtb_defaultValue()
        }
        return value
    }
    
    @inline(__always)
    public func dtb_isInvalid() -> Bool {
        return self?.dtb_isInvalid() ?? true
    }
    
    @inline(__always)
    public func dtb_isValid() -> Bool {
        return !dtb_isInvalid()
    }
}

extension Optional where Wrapped: DTB.NumberCheckable {
    
    @inline(__always)
    public func dtb_isInvalidOrZero() -> Bool {
        return dtb_isInvalid() || (self?.dtb_isZero() ?? false)
    }
    
    @inline(__always)
    public func dtb_isPositive() -> Bool {
        return dtb_isValid() && (self?.dtb_isPositive() ?? false)
    }
    
    @inline(__always)
    public func dtb_isNegative() -> Bool {
        return dtb_isValid() && (self?.dtb_isNegative() ?? false)
    }
}

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

import Foundation

extension DTB {
    
    /// - Optional 兜底
    public struct OptionalChecker {
        
        // MARK: - 通用
        
        /// value 为 nil / 无效时返回 ``def ?? dtb_defaultValue()``。
        @inline(__always)
        public func `or`<E>(_ value: E?, def: E? = nil) -> E where E: DTB.OptionalCheckable {
            if let value = value, !value.dtb_isInvalid() {
                return value
            }
            return def ?? E.dtb_defaultValue()
        }
        
        /// value 为 nil / 无效时返回 true。
        @inline(__always)
        public func isInvalid<E>(_ value: E?) -> Bool where E: DTB.OptionalCheckable {
            return value.map { $0.dtb_isInvalid() } ?? true
        }
        
        /// value 非 nil 且有效时返回 true。
        @inline(__always)
        public func isValid<E>(_ value: E?) -> Bool where E: DTB.OptionalCheckable {
            return !isInvalid(value)
        }
        
        // MARK: - 数字
        
        /// value 为 nil / 无效 / 零时返回 true。
        @inline(__always)
        public func isInvalidOrZero<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return !isValid(value) || value?.dtb_isZero() == true
        }
        
        /// value 有效且 > 0。
        @inline(__always)
        public func isPositive<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return isValid(value) && value?.dtb_isPositive() == true
        }
        
        /// value 有效且 < 0。
        @inline(__always)
        public func isNegative<E>(_ value: E?) -> Bool where E: DTB.NumberCheckable {
            return isValid(value) && value?.dtb_isNegative() == true
        }
    }
}

// MARK: - 为什么没有 a?.dtb.or() 这种链式写法
//
// `?` 之后的整条后缀表达式结果恒为 Optional，`Wrapper<T>` 上的方法无论如何都返回 T?，
// 无法在链上完成 Optional -> T 的坍塌。
//
// 对 Optional 加扩展可行，但需要写成 `(a?.dtb).or()`（括号冻结类型），
// 或另建 `a.dtb` 接收者（多一层包装器 + 同一标识符两种含义）。
// 二者都不优于参数位形式 `DTB.check.or(value)`，故不提供。

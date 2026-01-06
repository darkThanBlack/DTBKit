//
//  Array+DTBKit.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/7/12
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import Foundation

extension Wrapper {
    
    /// Safe array | 数组防越界
    ///
    /// * Sample: ``list[0] => list.dtb[0]``
    /// ``~=``: ``Swift/Collection/Range`` | ``Swift/Misc``,  [refer](https://github.com/swiftlang/swift/blob/ed38b93469c980cbe6d5459798cb8ad8d43bd9a8/stdlib/public/core/StringComparable.swift#L86)
    @inline(__always)
    public subscript<T>(_ index: Int?) -> T? where Base == Array<T> {
        if let idx = index, me.startIndex..<me.endIndex ~= idx {
            return me[idx]
        } else {
            return nil
        }
    }
    
    /// Safe subscript with Range | 安全的 Range 下标访问
    @inline(__always)
    public subscript<T>(_ range: Range<Int>) -> ArraySlice<T> where Base == Array<T> {
        guard me.count > 0 else { return ArraySlice<T>() }
        let safeStart = Swift.max(me.startIndex, Swift.min(range.lowerBound, me.endIndex))
        let safeEnd = Swift.max(safeStart, Swift.min(range.upperBound, me.endIndex))
        guard safeStart < safeEnd else { return ArraySlice<T>() }
        return me[safeStart..<safeEnd]
    }
    
    /// Safe subscript with ClosedRange | 安全的 ClosedRange 下标访问
    @inline(__always)
    public subscript<T>(_ range: ClosedRange<Int>) -> ArraySlice<T> where Base == Array<T> {
        guard me.count > 0 else { return ArraySlice<T>() }
        let safeStart = Swift.max(me.startIndex, Swift.min(range.lowerBound, me.endIndex))
        let safeEnd = Swift.max(safeStart, Swift.min(range.upperBound + 1, me.endIndex))
        guard safeStart < safeEnd else { return ArraySlice<T>() }
        return me[safeStart..<safeEnd]
    }
}

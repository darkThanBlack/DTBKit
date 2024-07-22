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

extension DTBKitWrapper {
    
    /// Safe array
    ///
    /// * Sample: ``list[0] => list.xm[0]``
    /// ``~=``: ``Swift/Misc``, and [refer](https://github.com/swiftlang/swift/blob/ed38b93469c980cbe6d5459798cb8ad8d43bd9a8/stdlib/public/core/StringComparable.swift#L86)
    public subscript<T>(_ index: Int?) -> T? where Base == Array<T> {
        guard let idx = index else {
            return nil
        }
        guard me.startIndex..<me.endIndex ~= idx else {
            return nil
        }
        return me[idx]
    }
}

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
    /// 数组防越界
    ///
    /// * Sample: ``list[0] => list.xm[0]``
    /// ``~=``: ``Swift/Collection/Range``
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

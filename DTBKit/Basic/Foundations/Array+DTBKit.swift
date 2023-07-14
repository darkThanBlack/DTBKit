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
    ///
    public subscript<T>(_ index: Int) -> T? where Base == Array<T> {
        guard mySelf.startIndex..<mySelf.endIndex ~= index else {
            return nil
        }
        return mySelf[index]
    }
}

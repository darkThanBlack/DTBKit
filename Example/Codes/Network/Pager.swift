//
//  Pager.swift
//  Ring
//
//  Created by moonShadow on 2026/6/17
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    public struct Pager<T> {
        public var list: [T]
        public var current: Int64
        public var total: Int64
        public var hasNext: Bool
        public init(list: [T], current: Int64, total: Int64? = nil, hasNext: Bool) {
            self.list = list
            self.current = current
            self.total = total ?? 0
            self.hasNext = hasNext
        }
    }
}

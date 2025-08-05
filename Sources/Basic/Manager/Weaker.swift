//
//  Weaker.swift
//  DTBKit
//
//  Created by moonShadow on 2025/3/25
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// 弱引用包装器
    ///
    /// Weak wrapper
    public class Weaker<T: AnyObject> {
        
        public weak var value: T?
        
        public init(_ value: T? = nil) {
            self.value = value
        }
    }
}

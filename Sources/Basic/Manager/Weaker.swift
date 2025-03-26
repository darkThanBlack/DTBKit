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
    
    /// 弱引用字典包装器
    public class Weaker<T: AnyObject> {
        weak var me: T?
        
        init(_ me: T? = nil) {
            self.me = me
        }
    }
}

//
//  ChainManager.swift
//  DTBKit_Basic
//
//  Created by moonShadow on 2026/1/7
//  Copyright © 2026 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    public final class ChainManager {
        
        public static let shared = ChainManager()
        private init() {}
        
        /// 将 target 设为 tmp，然后执行 handler；完毕后，立即将 target 的值重设为原始值。非线程安全。
        @inline(__always)
        public func rollback<Value, Result>(_ target: inout Value, _ tmp: Value, handler: (() -> Result)) -> Result {
            let oldValue = target
            target = tmp
            let result = handler()
            target = oldValue
            return result
        }
        
    }
}

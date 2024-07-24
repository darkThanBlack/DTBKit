//
//  DTBPerformance.swift
//  DTBKit
//
//  Created by moonShadow on 2024/7/24
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// Memory holder
    ///
    /// 持有在内存中
    final class Performance {
        
        static let shared = DTB.Performance()
        private init() {}
        
        /// Available for ``Bundle(identifier:)`` cache
        ///
        /// key: bundle name  value: loaded bundle identifier
        var loadedBundles: [String: String] = [:]
        
        ///
        static let decimalBehavior = NSDecimalNumberHandler(
            roundingMode: .plain,
            scale: 2,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false
        )
        
        // MARK: - Design
        
        /// UI design base size
        ///
        /// 设计稿基础尺寸
        var designBaseSize = CGSize(width: 375.0, height: 667.0)
        
        /// Update UI design base size
        ///
        /// 允许更新设计稿基础尺寸
        func updateDesignBaseSize(_ value: CGSize) {
            self.designBaseSize = value
        }
    }
}

//
//  DTBConfiguration.swift
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
    
    public final class Configuration {
        
        public static let shared = DTB.Configuration()
        private init() {}
        
        var decimalBehavior = NSDecimalNumberHandler(
            roundingMode: .plain,
            scale: 2,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false
        )
        
        var designBaseSize = CGSize(width: 375.0, height: 667.0)
        
        var supportImageTypes = ["png", "jpg", "webp", "jpeg"]
        
        /// 参见 ``NSDecimalNumber+DTBKit``
        ///
        /// 精度计算默认配置
        public func updateDecimalBehavior(_ value: NSDecimalNumberHandler) {
            self.decimalBehavior = value
        }
        
        /// 参见 ``func hf(_ behavior: DTB.HFBehaviors = .scale) -> CGFloat``
        ///
        /// 设计稿基础尺寸
        public func updateDesignBaseSize(_ value: CGSize) {
            self.designBaseSize = value
        }
        
        /// 参见 ``UIImage.xm.create()``
        ///
        /// 在 bundle 里按 name 搜索图片时的 type 参数
        public func updateSupportImageTypes(_ value: [String]) {
            self.supportImageTypes = value
        }
    }
}

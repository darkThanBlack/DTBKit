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
    
    /// Like ``UIAppearance``, store some parameters that use for default values.
    ///
    /// 仿照 ``UIAppearance`` 的思路，存储一些用作默认值的数据。
    /// 主要是为了处理某些冷门参数，业务层没必要提供接口，但又需要整体修改的情况。
    public final class Configuration {
        
        public static let shared = DTB.Configuration()
        private init() {}
        
        public private(set) var decimalBehavior = NSDecimalNumberHandler(
            roundingMode: .plain,
            scale: 2,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false
        )
        
        var designBaseSize = CGSize(width: 375.0, height: 667.0)
        
        var supportImageTypes = ["png", "jpg", "webp", "jpeg"]
        
        /// More detail: ``NSDecimalNumber+DTBKit.swift``
        ///
        /// 精度计算默认配置
        ///
        /// Default: ``NSDecimalNumberHandler(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)``
        public func updateDecimalBehavior(_ value: NSDecimalNumberHandler) {
            self.decimalBehavior = value
        }
        
        /// More detail: ``func hf(_ behavior: DTB.HFBehaviors = .scale) -> CGFloat``
        ///
        /// 设计稿基础尺寸
        ///
        /// Default: ``CGSize(width: 375.0, height: 667.0)``
        public func updateDesignBaseSize(_ value: CGSize) {
            self.designBaseSize = value
        }
        
        /// More detail: ``UIImage.xm.create()``
        ///
        /// 在 bundle 里按 name 搜索图片时，按照这个 type 参数依次搜索
        ///
        /// Default: ``["png", "jpg", "webp", "jpeg"]``
        public func updateSupportImageTypes(_ value: [String]) {
            self.supportImageTypes = value
        }
    }
}

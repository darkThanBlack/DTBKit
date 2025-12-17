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
    ///
    /// 什么时候使用？
    /// 当某些参数有可能：
    ///  - 需要全局使用
    ///  - 使用同一个对象可以节省内存
    ///
    ///  为什么单例？
    ///  - 默认行为有且只有一种
    ///  - 结构简单，没必要使用 Provider
    ///  - 写一次，读多次，并且用户不读，没必要放到 DTB.app
    public final class Configuration {
        
        public static let shared = DTB.Configuration()
        private init() {}
        
        public private(set) var decimalBehavior = {
#if DEBUG
            return  NSDecimalNumberHandler(
                roundingMode: .plain,
                scale: 2,
                raiseOnExactness: true,
                raiseOnOverflow: true,
                raiseOnUnderflow: true,
                raiseOnDivideByZero: true
            )
#else
            return  NSDecimalNumberHandler(
                roundingMode: .plain,
                scale: 2,
                raiseOnExactness: false,
                raiseOnOverflow: false,
                raiseOnUnderflow: false,
                raiseOnDivideByZero: false
            )
#endif
        }()
        
        public private(set) var designBaseSize = CGSize(width: 375.0, height: 667.0)
        
        public private(set) var supportImageTypes = ["png", "jpg", "webp", "jpeg"]
        
        public private(set) var numberFormatter = NumberFormatter()
        
        public private(set) var dateFormatter = DateFormatter()
        
    }
}

extension DTB.Configuration {
    
    /// More detail: ``NSDecimalNumber+DTBKit.swift``
    ///
    /// 精度计算默认配置
    ///
    /// Default:
    /// ```
    /// NSDecimalNumberHandler(
    ///    roundingMode: .plain,
    ///    scale: 2,
    ///    raiseOnExactness: false,
    ///    raiseOnOverflow: false,
    ///    raiseOnUnderflow: false,
    ///    raiseOnDivideByZero: false
    ///)
    /// ```
    public func setDecimalBehavior(_ value: NSDecimalNumberHandler) {
        self.decimalBehavior = value
    }
    
    /// More detail: ``func hf(_ behavior: DTB.HFBehaviors = .scale) -> CGFloat``
    ///
    /// 设计稿基础尺寸
    ///
    /// Default:
    /// ```
    /// CGSize(width: 375.0, height: 667.0)
    /// ```
    public func setDesignBaseSize(_ value: CGSize) {
        self.designBaseSize = value
    }
    
    /// More detail: ``UIImage.dtb.create()``
    ///
    /// 在 bundle 里按 name 搜索图片时，按照这个 type 参数依次搜索
    ///
    /// Default:
    /// ```
    /// ["png", "jpg", "webp", "jpeg"]
    /// ```
    public func setSupportImageTypes(_ value: [String]) {
        self.supportImageTypes = value
    }
    
    public func setNumberFormatter(_ value: NumberFormatter) {
        self.numberFormatter = value
    }
    
    public func setDateFormatter(_ value: DateFormatter) {
        self.dateFormatter = value
    }
    
}

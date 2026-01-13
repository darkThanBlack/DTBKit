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
    /// 设计目的？
    ///  - 某些方法和参数需要一个默认值，但这个默认值又可能因为开发者习惯不同而变化
    ///  - 使用同一个对象可以节省内存
    ///
    ///  为什么使用单例？
    ///  - 默认值有且只有一种，不需要处理业务逻辑，所以没必要使用 Provider
    ///  - 使用场景是单次写入，多次读取，没必要放到 DTB.app
    ///
    ///  风险？
    ///  - 错误使用会导致 BUG 复现依赖于代码执行顺序
    public final class ConfigManager {
        
        public static let shared = DTB.ConfigManager()
        
        // MARK: - Custom
        
        /// 设计稿基础尺寸
        ///
        /// More detail: ``HighFidelity+Basic.swift``
        public private(set) var designBaseSize: CGSize
        
        /// 在 bundle 里按 name 搜索图片时，按照这个 type 参数依次搜索
        ///
        /// More detail: ``UIImage.dtb.create()``
        public private(set) var supportImageTypes: [String]
        
        // MARK: - Decimal
        
        /// Default roundingMode: plain, scale: 15
        ///
        /// More detail: ``NSDecimalNumber+Basic.swift``
        public private(set) var decimalBehavior: NSDecimalNumberHandler
        
        // MARK: - Time
        
        /// Default is ``Asia/Shanghai``, NOT ``current``
        public private(set) var timeZone: TimeZone
        
        /// Default is ``zh-CN``, NOT ``current``
        public private(set) var locale: Locale
        
        /// Default is gregorian, NOT ``current``
        public private(set) var calendar: Calendar
        
        // MARK: - Formatter
        
        /// - Note: locale will auto change with self
        public private(set) var numberFormatter: NumberFormatter
        
        /// Default dateFormat: "yyyy-MM-dd HH:mm:ss"
        ///
        /// - Note: calendar will auto change with self
        public private(set) var dateFormatter: DateFormatter
        
        private init() {
            
            let decimalBehavior = {
                return NSDecimalNumberHandler(
                    roundingMode: .plain,
                    scale: 15,
                    raiseOnExactness: DTB.app.isDebug(),
                    raiseOnOverflow: DTB.app.isDebug(),
                    raiseOnUnderflow: DTB.app.isDebug(),
                    raiseOnDivideByZero: DTB.app.isDebug()
                )
            }()
            
            let designBaseSize = CGSize(width: 375.0, height: 667.0)
            let supportImageTypes = ["png", "jpg", "webp", "jpeg"]
            
            let timeZone = TimeZone(identifier: "Asia/Shanghai") ?? TimeZone(secondsFromGMT: 8 * 3600) ?? TimeZone.current
            let locale = Locale(identifier: "zh-CN")
            let calendar = {
                var c = Calendar(identifier: .gregorian)
                c.locale = locale
                c.timeZone = timeZone
                return c
            }()
            let numberFormatter = {
                let f = NumberFormatter()
                f.locale = locale
                return f
            }()
            let dateFormatter = {
                let f = DateFormatter()
                f.timeZone = timeZone
                f.locale = locale
                f.calendar = calendar
                f.dateFormat = "yyyy-MM-dd HH:mm:ss"
                return f
            }()
            
            self.designBaseSize = designBaseSize
            self.supportImageTypes = supportImageTypes
            self.decimalBehavior = decimalBehavior
            self.timeZone = timeZone
            self.locale = locale
            self.calendar = calendar
            self.numberFormatter = numberFormatter
            self.dateFormatter = dateFormatter
        }
    }
}

extension DTB.ConfigManager {
    
    public func setDecimalBehavior(_ value: NSDecimalNumberHandler) {
        self.decimalBehavior = value
    }
    
    public func setDesignBaseSize(_ value: CGSize) {
        self.designBaseSize = value
    }
    
    public func setSupportImageTypes(_ value: [String]) {
        self.supportImageTypes = value
    }
    
    /// 全局时间设置
    ///
    /// Calendar 依赖 TimeZone 和 Locale
    ///
    /// - Note: 会以传入的 timeZone 和 locale 为准，更新 calendar；同时所有拥有 calendar 属性的对象都会更新，比如 numberFormatter 和 dateFormatter
    public func setTime(zone: TimeZone, locale: Locale, calendarIdentifier: Calendar.Identifier = .gregorian) {
        self.timeZone = zone
        self.locale = locale
        
        var calendar = Calendar(identifier: calendarIdentifier)
        calendar.timeZone = zone
        calendar.locale = locale
        self.calendar = calendar
        
        self.numberFormatter.locale = locale
        self.dateFormatter.calendar = calendar
        
        DTB.console.log("Time changed: TimeZone=\(zone.identifier), Locale=\(locale.identifier), Calendar=\(calendarIdentifier)")
    }
    
    /// 全局时间设置
    ///
    /// - Note: 会以传入的 Calendar 为准，更新 timeZone 和 locale；同时所有拥有 calendar 属性的对象都会更新，比如 numberFormatter 和 dateFormatter
    public func setCalendar(_ calendar: Calendar) {
        // 以 Calendar 为权威，提取其配置
        self.calendar = calendar
        self.timeZone = calendar.timeZone
        self.locale = calendar.locale ?? self.locale  // Calendar.locale 可能为 nil
        
        self.numberFormatter.locale = self.locale
        self.dateFormatter.calendar = calendar
        
        DTB.console.log("Time changed: TimeZone=\(timeZone.identifier), Locale=\(locale.identifier), Calendar=\(calendar.identifier)")
    }
    
    public func setNumberFormatter(_ value: NumberFormatter) {
        self.numberFormatter = value
    }
    
    public func setDateFormatter(_ value: DateFormatter) {
        self.dateFormatter = value
    }
    
}

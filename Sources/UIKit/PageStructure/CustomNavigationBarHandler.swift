//
//  CustomNavigationBar.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/22
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// Abstract protocol
    public protocol CustomNavigationBar: UIView {
        
        /// 数据模型
        associatedtype ConfigType
        
        /// 更新 UI
        func update(with config: ConfigType)
        
        /// 反推状态栏样式
        func getStatusBarStyle() -> UIStatusBarStyle
    }
    
    /// Abstract protocol
    ///
    /// 1> 定义自己的 protocol，遵循这个协议
    /// 2> 提供默认实现
    /// 3> 让自己的 BaseViewController 实现自己的 protocol
    ///
    /// e.g. 参见 SimpleNavigationBarHandler
    public protocol CustomNavigationBarHandler: UIViewController {
        
        associatedtype BarType: CustomNavigationBar
        
        var customNavigationBar: BarType { get }
        
        func setupNavigatonBar(with config: BarType.ConfigType)
    }
}

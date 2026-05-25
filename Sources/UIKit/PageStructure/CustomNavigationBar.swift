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
        
        associatedtype ConfigType
        
        func update(with config: ConfigType)
    }
    
    /// Abstract protocol
    public protocol CustomNavigationBarHandler: UIViewController {
        
        associatedtype BarType: CustomNavigationBar
        
        var customNavigationBar: BarType { get }
        
        func setupCustomNavigatonBar(with config: BarType.ConfigType)
    }
}

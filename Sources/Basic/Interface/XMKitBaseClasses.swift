//
//  DTBKitBaseClasses.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/10
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

/// Base class name space.
///
/// 基类定义
///
/// 考虑到 UIKit 结构限制，不得不设计一部分基类
public protocol BaseClasses {
    
    ///
    associatedtype NavigationController: UINavigationController
    
    ///
    associatedtype ViewController: UIViewController
    
    ///
    associatedtype TableViewCell: UITableViewCell
}

extension BaseClasses {
    
    public typealias NavigationController = UINavigationController
    
    public typealias ViewController = UIViewController
    
    public typealias TableViewCell = UITableViewCell
}

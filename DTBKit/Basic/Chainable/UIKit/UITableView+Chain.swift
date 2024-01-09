//
//  UITableView+Chain.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/9
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension XMKitWrapper where Base: UITableView {
    
    @discardableResult
    public func dataSource(_ value: UITableViewDataSource?) -> Self {
        me.dataSource = value
        return self
    }

    @discardableResult
    public func delegate(_ value: UITableViewDelegate?) -> Self {
        me.delegate = value
        return self
    }
    
    @available(iOS 10.0, *)
    @discardableResult
    public func prefetchDataSource(_ value: UITableViewDataSourcePrefetching?) -> Self {
        me.prefetchDataSource = value
        return self
    }
    
    @available(iOS 15.0, *)
    @discardableResult
    public func isPrefetchingEnabled(_ value: Bool) -> Self {
        me.isPrefetchingEnabled = value
        return self
    }
    
    
    
//    @available(iOS 11.0, *)
//    weak open var dragDelegate: UITableViewDragDelegate?
//
//    @available(iOS 11.0, *)
//    weak open var dropDelegate: UITableViewDropDelegate?
//
//    
//    open var rowHeight: CGFloat // default is UITableViewAutomaticDimension
//
//    open var sectionHeaderHeight: CGFloat // default is UITableViewAutomaticDimension
//
//    open var sectionFooterHeight: CGFloat // default is UITableViewAutomaticDimension
//
//    @available(iOS 7.0, *)
//    open var estimatedRowHeight: CGFloat // default is UITableViewAutomaticDimension, set to 0 to disable
//
//    @available(iOS 7.0, *)
//    open var estimatedSectionHeaderHeight: CGFloat // default is UITableViewAutomaticDimension, set to 0 to disable
//
//    @available(iOS 7.0, *)
//    open var estimatedSectionFooterHeight: CGFloat // default is UITableViewAutomaticDimension, set to 0 to disable

    
}

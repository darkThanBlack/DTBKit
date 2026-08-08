//
//  PageRequestable.swift
//  Ring
//
//  Created by moonShadow on 2026/6/17
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    public protocol PageRequestable: AnyObject {
        
        /// 业务层最终要给 UI 的模型（User、Product…）
        associatedtype ItemModel
        /// 数据源
        var dataList: [ItemModel] { get set }
        
        /// 页码从 x 开始，只读
        var firstPage: Int64 { get }
        /// 每页大小，只读
        var pageSize: Int64 { get }
        
        /// 当前页码
        var currentPage: Int64 { get set }
        /// 是否还有下一页
        var hasNextPage: Bool { get set }
        
        /// 更新数据源; 允许异步，用于应对线程同步等场景
        func updateDataList(isRefresh: Bool, list: [ItemModel],  completedHandler: @escaping ((_ dataList: [ItemModel]) -> ()))
        
        /// 请求结束时调用，状态更新（把 current、hasNext 写回内部属性）
        func updatePage(current: Int64, hasNext: Bool)
        
        /// 基于 Swift.Result 的请求实现
        ///
        /// 可以选择不实现，然后对协议进行扩展，外部调自己的请求方法
        func requestPage(current: Int64, size: Int64, completedHandler: @escaping (Swift.Result<DTB.Pager<ItemModel>, Error>) -> Void)
    }
}

public extension DTB.PageRequestable {
    
    var firstPage: Int64 { return 0 }
    
    var pageSize: Int64 { return 20 }
    
    func requestPage(current: Int64, size: Int64, completedHandler: @escaping (Swift.Result<DTB.Pager<ItemModel>, Error>) -> Void) {
        completedHandler(.failure(NSError.dtb.create("fatal error: 错误的方法调用，或子类没有正确实现")))
    }
    
    func updateDataList(isRefresh: Bool, list: [ItemModel], completedHandler: @escaping ((_ dataList: [ItemModel]) -> ())) {
        if isRefresh {
            dataList = list
        } else {
            dataList += list
        }
        completedHandler(dataList)
    }
    
    func updatePage(current: Int64, hasNext: Bool) {
        self.currentPage = current
        self.hasNextPage = hasNext
    }
}

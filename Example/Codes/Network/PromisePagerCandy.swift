//
//  DefaultPagerCandy.swift
//  Ring
//
//  Created by moonShadow on 2026/6/17
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

import PromiseKit

extension DTB {
    
    public protocol PromisePageRequestable: DTB.PageRequestable {
        
        func requestPagePromise(current: Int64, size: Int64) -> Promise<DTB.Pager<ItemModel>>
        
        func updateDataListPromise(isRefresh: Bool, list: [ItemModel]) -> Promise<[ItemModel]>
    }
}

extension DTB.PromisePageRequestable {
    
    func requestPagePromise(current: Int64, size: Int64) -> Promise<DTB.Pager<ItemModel>> {
        return Promise.init(error: NSError.dtb.create("fatal error: 错误的方法调用，或子类没有正确实现"))
    }
    
    func updateDataListPromise(isRefresh: Bool, list: [ItemModel]) -> Promise<[ItemModel]> {
        return Promise<[ItemModel]> { seal in
            if isRefresh {
                dataList = list
            } else {
                dataList += list
            }
            seal.fulfill(dataList)
        }
    }
}

extension DTB {
    
    ///
    public final class PromisePagerCandy<Model: DTB.PromisePageRequestable, View: DTB.PullDownRefreshable> {
        
        public weak var dataProvider: Model? = nil
        
        public weak var uiProvider: View? = nil
        
        public var dataListDidChangedPromiseHandler: ((Promise<[Model.ItemModel]>) -> ())? = nil
        
        public func bind(model: Model?, view: View?, dataListDidChangedPromiseHandler: ((Promise<[Model.ItemModel]>) -> ())? = nil) {
            self.dataProvider = model
            self.uiProvider = view
            if let handler = dataListDidChangedPromiseHandler {
                self.dataListDidChangedPromiseHandler = handler
            } else {
                // 默认刷新方法
                //
                // 尝试调用 refreshView 对象的 reloadData
                self.dataListDidChangedPromiseHandler = { [weak self] p in
                    p.done { _ in
                        if let tableView = self?.uiProvider?.refreshView as? UITableView {
                            tableView.reloadData()
                        }
                        if let collectionView = self?.uiProvider?.refreshView as? UICollectionView {
                            collectionView.reloadData()
                        }
                        DTB.console.error("dataListDidChangedHandler is nil")
                    }.cauterize()
                }
            }
            uiProvider?.onPullDownRefresh = { [weak self] in
                if let p = self?.requestPage(isRefresh: true) {
                    self?.dataListDidChangedPromiseHandler?(p)
                }
            }
            uiProvider?.onLoadMore = { [weak self] in
                if let p = self?.requestPage(isRefresh: false) {
                    self?.dataListDidChangedPromiseHandler?(p)
                }
            }
            
            uiProvider?.setupRefreshUI()
        }
        
        /// 外部触发请求
        ///
        /// isRefresh: 是下拉刷新，重置 currentPage
        public func requestPage(isRefresh: Bool) -> Promise<[Model.ItemModel]> {
            guard let data = dataProvider, let ui = uiProvider else {
                return Promise(error: NSError.dtb.create("fatal error: dataProvider or uiProvider is nil"))
            }
            // 已经没有更多数据，直接结束
            guard data.hasNextPage else {
                uiProvider?.endRefreshing(hasMore: false)
                return Promise.value(data.dataList)
            }
            // 构建参数
            let current = isRefresh ? data.firstPage : (data.currentPage + 1)
            return data.requestPagePromise(current: current, size: data.pageSize)
                .then { pager -> Promise<[Model.ItemModel]> in
                    ui.endRefreshing(hasMore: pager.hasNext)
                    return data.updateDataListPromise(isRefresh: isRefresh, list: pager.list)
                }
                .recover { error -> Promise<[Model.ItemModel]> in
                    ui.endRefreshing(hasMore: data.hasNextPage)
                    return Promise(error: error)
                }
        }
        
    }
    
}

//
//  PagerCandy.swift
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
    
    public final class PagerCandy<Model: DTB.PageRequestable, View: DTB.PullDownRefreshable> {
        
        public weak var dataProvider: Model? = nil
        
        public weak var uiProvider: View? = nil
        
        public var dataListDidChangedHandler: ((Swift.Result<[Model.ItemModel], any Error>) -> ())? = nil
        
        ///
        public func bind(model: Model?, view: View?, dataListDidChangedHandler: ((Swift.Result<[Model.ItemModel], Error>) -> ())?) {
            dataProvider = model
            uiProvider = view
            
            if let handler = dataListDidChangedHandler {
                self.dataListDidChangedHandler = handler
            } else {
                // 默认刷新方法
                //
                // 尝试调用 refreshView 对象的 reloadData
                self.dataListDidChangedHandler = { [weak self] _ in
                    if let tableView = self?.uiProvider?.refreshView as? UITableView {
                        tableView.reloadData()
                    }
                    if let collectionView = self?.uiProvider?.refreshView as? UICollectionView {
                        collectionView.reloadData()
                    }
                    DTB.console.error("dataListDidChangedHandler is nil")
                }
            }
            
            uiProvider?.onPullDownRefresh = { [weak self] in
                self?.requestPage(isRefresh: true)
            }
            uiProvider?.onLoadMore = { [weak self] in
                self?.requestPage(isRefresh: false)
            }
            
            uiProvider?.setupRefreshUI()
        }
        
        /// 外部触发请求
        ///
        /// isRefresh: 是下拉刷新，重置 currentPage
        public func requestPage(isRefresh: Bool) {
            guard let data = dataProvider, let ui = uiProvider else { return }
            // 已经没有更多数据，直接结束
            guard data.hasNextPage else {
                uiProvider?.endRefreshing(hasMore: false)
                dataListDidChangedHandler?(.success(data.dataList))
                return
            }
            // 构建参数
            let current = isRefresh ? data.firstPage : (data.currentPage + 1)
            data.requestPage(current: current, size: data.pageSize) { [weak self] result in
                switch result {
                case .success(let pager):
                    data.updateDataList(isRefresh: isRefresh, list: pager.list) { dataList in
                        ui.endRefreshing(hasMore: pager.hasNext)
                        self?.dataListDidChangedHandler?(.success(dataList))
                    }
                case .failure(let error):
                    ui.endRefreshing(hasMore: data.hasNextPage)
                    self?.dataListDidChangedHandler?(.failure(error))
                }
            }
        }
        
    }
    
}

//
//  RefreshUIProvider.swift
//  Ring
//
//  Created by moonShadow on 2026/6/17
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import MJRefresh

extension DTB {
    
    public protocol PullDownRefreshable: AnyObject {
        /// 需要刷新的滚动视图（UITableView / UICollectionView / UIScrollView）
        var refreshView: UIScrollView? { get }
        /// 当用户下拉触发刷新时的回调
        var onPullDownRefresh: (() -> Void)? { get set }
        /// 当用户上拉触发加载更多时的回调
        var onLoadMore: (() -> Void)? { get set }
        
        /// 创建 MJRefresh 组件（只创建一次，外部决定是否立即触发下拉请求）
        func setupRefreshUI(beginRefresh: Bool)
        /// 在请求结束后，外部调用此方法来结束对应的刷新动画
        func endRefreshing(hasMore: Bool)
    }
}

public extension DTB.PullDownRefreshable {
    
    func setupRefreshUI(beginRefresh: Bool = true) {
        guard let view = refreshView else { return }
        // Header
        if view.mj_header == nil {
            view.mj_header = {
                if let p = DTB.Providers.get(DTB.Providers.mjRefreshHeaderKey), let header = p.create(nil) {
                    header.refreshingBlock = { [weak self] in
                        self?.onPullDownRefresh?()
                    }
                    return header
                }
                return MJRefreshNormalHeader { [weak self] in
                    self?.onPullDownRefresh?()
                }
            }()
        }
        // Footer
        if view.mj_footer == nil {
            view.mj_footer = {
                if let p = DTB.Providers.get(DTB.Providers.mjRefreshFooterKey), let footer = p.create(nil) {
                    footer.refreshingBlock = { [weak self] in
                        self?.onLoadMore?()
                    }
                    return footer
                }
                return MJRefreshAutoNormalFooter { [weak self] in
                    self?.onLoadMore?()
                }
            }()
        }
        
        if beginRefresh {
            view.mj_header?.beginRefreshing()
        }
    }
    
    func endRefreshing(hasMore: Bool) {
        refreshView?.mj_header?.endRefreshing()
        if hasMore {
            refreshView?.mj_footer?.endRefreshing()
        } else {
            refreshView?.mj_footer?.endRefreshingWithNoMoreData()
        }
    }
}

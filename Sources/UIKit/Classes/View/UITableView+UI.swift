//
//  UITableView+UI.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/9
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension StaticWrapper where T: UITableView {
    
    ///
    public func plain<C>(
        _ controllerOrAnother: C?,
        cells: [AnyClass],
        headerFooters: [AnyClass]? = nil
    ) -> UITableView where C: UITableViewDelegate, C: UITableViewDataSource {
        let tableView = UITableView(frame: .zero, style: .plain)
        setup(tableView: tableView, controllerOrAnother: controllerOrAnother, cells: cells, headerFooters: headerFooters)
        return tableView
    }
    
    ///
    public func grouped<C>(
        _ controllerOrAnother: C?,
        cells: [AnyClass]? = nil,
        headerFooters: [AnyClass]? = nil
    ) -> UITableView where C: UITableViewDelegate, C: UITableViewDataSource {
        let tableView = UITableView(frame: .zero, style: .grouped)
        setup(tableView: tableView, controllerOrAnother: controllerOrAnother, cells: cells, headerFooters: headerFooters)
        return tableView
    }
    
    ///
    private func setup<C>(
        tableView: UITableView,
        controllerOrAnother: C?,
        cells: [AnyClass]? = nil,
        headerFooters: [AnyClass]? = nil
    ) where C: UITableViewDelegate, C: UITableViewDataSource {
        tableView.backgroundColor = {
            if let vc = controllerOrAnother as? UIViewController {
                return vc.view.backgroundColor
            }
            if let view = controllerOrAnother as? UIView {
                return view.backgroundColor
            }
            return .white
        }()
        tableView.delegate = controllerOrAnother
        tableView.dataSource = controllerOrAnother
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44.0
        tableView.showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            if let vc = controllerOrAnother as? UIViewController {
                vc.automaticallyAdjustsScrollViewInsets = false
            }
        }
        cells?.forEach({ item in
            tableView.register(item, forCellReuseIdentifier: String(describing: item))
        })
        headerFooters?.forEach({ item in
            tableView.register(item, forHeaderFooterViewReuseIdentifier: String(describing: item))
        })
    }
}

extension DTB {
    
    ///
    public enum IndexOrder {
        /// 只有 1 个
        case onlyOne
        /// 是列表里的第 1 个
        case isFirst
        /// 是普通元素
        case isMiddle
        /// 是列表里的最后 1 个
        case isLast
    }
}

extension Wrapper where Base: UITableView {
    
    /// 判断 cell 在 section 中的位置
    public func indexOrder(_ indexPath: IndexPath, from tableView: UITableView) -> DTB.IndexOrder {
        let count = tableView.numberOfRows(inSection: indexPath.section)
        if count < 2 {
            return .onlyOne
        }
        if indexPath.row == 0 {
            return .isFirst
        }
        if indexPath.row == count - 1 {
            return .isLast
        }
        return .isMiddle
    }
}

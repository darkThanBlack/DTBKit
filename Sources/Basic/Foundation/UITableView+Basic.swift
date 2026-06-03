//
//  UITableView+DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/10
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

extension Wrapper where Base: UITableView {
    
    // fully e.g.
    // ```
    // func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //     // old:
    //     guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DebugListCell.self)) as? DebugListCell else {
    //       return UITableViewCell()
    //     }
    //     cell.config(data)
    //     return cell
    //
    //     // new:
    //     guard indexPath.row < viewModel.cells.count, let data = viewModel.cells[indexPath.row] else {
    //         return UITableViewCell()
    //     }
    //     switch data.tag {
    //     case .list:
    //         let cell: MineListCell = tableView.dtb.dequeueReusableCell(indexPath)
    //         cell.config(data.list)
    //         return cell
    //     default:
    //         return UITableViewCell()
    //     }
    // }
    // ```
    
    /// Use ``String(describing: Cell.self)`` to cell identifier | 直接用类名作为重用标识
    ///
    /// More details in ``Explain.md``
    @discardableResult
    public func registerCell<T: UITableViewCell>(_ cellClass: T.Type) -> Self {
        me.register(T.self, forCellReuseIdentifier: String(describing: T.self))
        return self
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier | 直接用类名作为重用标识
    ///
    /// More details in ``Explain.md``
    @discardableResult
    public func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ aClass: T.Type) -> Self {
        me.register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
        return self
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier | 直接用类名作为重用标识
    ///
    /// More details in ``Explain.md``
    public func dequeueReusableCell<T: UITableViewCell>(_ indexPath: IndexPath) -> T? {
        return me.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier | 直接用类名作为重用标识
    ///
    /// More details in ``Explain.md``
    public func dequeueReusableCellEnsured<T: UITableViewCell>(_ indexPath: IndexPath) -> T {
        if let cell = me.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T {
            return cell
        }
        DTB.console.assert()
        return T()
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier | 直接用类名作为重用标识
    ///
    /// More details in ``Explain.md``
    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? {
        return me.dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier | 直接用类名作为重用标识
    ///
    /// More details in ``Explain.md``
    public func dequeueReusableHeaderFooterViewEnsured<T: UITableViewHeaderFooterView>() -> T? {
        if let view = me.dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T {
            return view
        }
        DTB.console.assert()
        return T()
    }
}

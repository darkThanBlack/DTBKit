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
        DTB.console.fail()
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
        DTB.console.fail()
        return T()
    }
}

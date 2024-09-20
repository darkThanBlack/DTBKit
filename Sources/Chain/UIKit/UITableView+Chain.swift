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

extension DTBKitWrapper where Base: UITableView {
    
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
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dragDelegate(_ value: UITableViewDragDelegate?) -> Self {
        me.dragDelegate = value
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dropDelegate(_ value: UITableViewDropDelegate?) -> Self {
        me.dropDelegate = value
        return self
    }
    
    @discardableResult
    public func rowHeight(_ value: CGFloat) -> Self {
        me.rowHeight = value
        return self
    }
    
    @discardableResult
    public func sectionHeaderHeight(_ value: CGFloat) -> Self {
        me.sectionHeaderHeight = value
        return self
    }

    @discardableResult
    public func sectionFooterHeight(_ value: CGFloat) -> Self {
        me.sectionFooterHeight = value
        return self
    }
    
    @discardableResult
    public func estimatedRowHeight(_ value: CGFloat) -> Self {
        me.estimatedRowHeight = value
        return self
    }
    
    @discardableResult
    public func estimatedSectionHeaderHeight(_ value: CGFloat) -> Self {
        me.estimatedSectionHeaderHeight = value
        return self
    }
    
    @discardableResult
    public func estimatedSectionFooterHeight(_ value: CGFloat) -> Self {
        me.estimatedSectionFooterHeight = value
        return self
    }
    
    /// [RUBBISH] 
    /// ``plain`` 模式下用默认 cell 填充底部空白。
    /// ```
    ///     UITableView.appearance().fillerRowHeight = 0
    /// ```
    @available(iOS 15.0, *)
    @discardableResult
    public func fillerRowHeight(_ value: CGFloat) -> Self {
        me.fillerRowHeight = value
        return self
    }
    
    /// [RUBBISH]
    /// 会导致 section 出现额外间距。
    /// ```
    ///     UITableView.appearance().sectionHeaderTopPadding = 0
    /// ```
    @available(iOS 15.0, *)
    @discardableResult
    public func sectionHeaderTopPadding(_ value: CGFloat) -> Self {
        me.sectionHeaderTopPadding = value
        return self
    }
    
    @discardableResult
    public func separatorInset(_ value: UIEdgeInsets) -> Self {
        me.separatorInset = value
        return self
    }
    
    @discardableResult
    public func separatorInsetReference(_ value: UITableView.SeparatorInsetReference) -> Self {
        me.separatorInsetReference = value
        return self
    }
    
    @available(iOS 16.0, *)
    @discardableResult
    public func selfSizingInvalidation(_ value: UITableView.SelfSizingInvalidation) -> Self {
        me.selfSizingInvalidation = value
        return self
    }
    
    @discardableResult
    public func backgroundView(_ value: UIView?) -> Self {
        me.backgroundView = value
        return self
    }
    
    @discardableResult
    public func scrollToRow(at indexPath: IndexPath, at scrollPosition: UITableView.ScrollPosition, animated: Bool) -> Self {
        me.scrollToRow(at: indexPath, at: scrollPosition, animated: animated)
        return self
    }
    
    @discardableResult
    public func scrollToNearestSelectedRow(at scrollPosition: UITableView.ScrollPosition, animated: Bool) -> Self {
        me.scrollToNearestSelectedRow(at: scrollPosition, animated: animated)
        return self
    }
}

/// Reloading and Updating
extension DTBKitWrapper where Base: UITableView {
    
    @available(iOS 11.0, *)
    @discardableResult
    public func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) -> Self {
        me.performBatchUpdates(updates, completion: completion)
        return self
    }
    
    @discardableResult
    public func beginUpdates() -> Self {
        me.beginUpdates()
        return self
    }
    
    @discardableResult
    public func endUpdates() -> Self {
        me.endUpdates()
        return self
    }
    
    @discardableResult
    public func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) -> Self {
        me.insertSections(sections, with: animation)
        return self
    }
    
    @discardableResult
    public func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) -> Self {
        me.deleteSections(sections, with: animation)
        return self
    }
    
    @discardableResult
    public func moveSection(_ section: Int, toSection newSection: Int) -> Self {
        me.moveSection(section, toSection: newSection)
        return self
    }
    
    @discardableResult
    public func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) -> Self {
        me.reloadSections(sections, with: animation)
        return self
    }
    
    @discardableResult
    public func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) -> Self {
        me.insertRows(at: indexPaths, with: animation)
        return self
    }
    
    @discardableResult
    public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) -> Self {
        me.deleteRows(at: indexPaths, with: animation)
        return self
    }
    
    @discardableResult
    public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) -> Self {
        me.moveRow(at: indexPath, to: newIndexPath)
        return self
    }
    
    @discardableResult
    public func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) -> Self {
        me.reloadRows(at: indexPaths, with: animation)
        return self
    }
    
    @available(iOS 15.0, *)
    @discardableResult
    public func reconfigureRows(at indexPaths: [IndexPath]) -> Self {
        me.reconfigureRows(at: indexPaths)
        return self
    }
    
    @discardableResult
    public func reloadData() -> Self {
        me.reloadData()
        return self
    }
    
    @discardableResult
    public func reloadSectionIndexTitles() -> Self {
        me.reloadSectionIndexTitles()
        return self
    }
    
    @discardableResult
    public func setEditing(_ editing: Bool, animated: Bool) -> Self {
        me.setEditing(editing, animated: animated)
        return self
    }
    
    @discardableResult
    public func allowsSelection(_ value: Bool) -> Self {
        me.allowsSelection = value
        return self
    }
    
    @discardableResult
    public func allowsSelectionDuringEditing(_ value: Bool) -> Self {
        me.allowsSelectionDuringEditing = value
        return self
    }
    
    @discardableResult
    public func allowsMultipleSelection(_ value: Bool) -> Self {
        me.allowsMultipleSelection = value
        return self
    }
    
    @discardableResult
    public func allowsMultipleSelectionDuringEditing(_ value: Bool) -> Self {
        me.allowsMultipleSelectionDuringEditing = value
        return self
    }
    
    @discardableResult
    public func selectRow(at indexPath: IndexPath?, animated: Bool, scrollPosition: UITableView.ScrollPosition) -> Self {
        me.selectRow(at: indexPath, animated: animated, scrollPosition: scrollPosition)
        return self
    }
    
    @discardableResult
    public func deselectRow(at indexPath: IndexPath, animated: Bool) -> Self {
        me.deselectRow(at: indexPath, animated: animated)
        return self
    }
}

/// Appearance
extension DTBKitWrapper where Base: UITableView {
    
    @discardableResult
    public func sectionIndexMinimumDisplayRowCount(_ value: Int) -> Self {
        me.sectionIndexMinimumDisplayRowCount = value
        return self
    }
    
    @discardableResult
    public func sectionIndexColor(_ value: UIColor?) -> Self {
        me.sectionIndexColor = value
        return self
    }

    @discardableResult
    public func sectionIndexBackgroundColor(_ value: UIColor?) -> Self {
        me.sectionIndexBackgroundColor = value
        return self
    }
    
    @discardableResult
    public func sectionIndexTrackingBackgroundColor(_ value: UIColor?) -> Self {
        me.sectionIndexTrackingBackgroundColor = value
        return self
    }
    
    @discardableResult
    public func separatorStyle(_ value: UITableViewCell.SeparatorStyle) -> Self {
        me.separatorStyle = value
        return self
    }
    
    @discardableResult
    public func separatorColor(_ value: UIColor?) -> Self {
        me.separatorColor = value
        return self
    }
    
    @discardableResult
    public func separatorEffect(_ value: UIVisualEffect?) -> Self {
        me.separatorEffect = value
        return self
    }
    
    @discardableResult
    public func cellLayoutMarginsFollowReadableWidth(_ value: Bool) -> Self {
        me.cellLayoutMarginsFollowReadableWidth = value
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func insetsContentViewsToSafeArea(_ value: Bool) -> Self {
        me.insetsContentViewsToSafeArea = value
        return self
    }
    
    @discardableResult
    public func tableHeaderView(_ value: UIView?) -> Self {
        me.tableHeaderView = value
        return self
    }
    
    @discardableResult
    public func tableFooterView(_ value: UIView?) -> Self {
        me.tableFooterView = value
        return self
    }
    
    @discardableResult
    public func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) -> Self {
        me.register(nib, forCellReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) -> Self {
        me.register(cellClass, forCellReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String) -> Self {
        me.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public func register(_ aClass: AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String) -> Self {
        me.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
        return self
    }
    
}

/// Focus
extension DTBKitWrapper where Base: UITableView {
    
    
    @discardableResult
    public func remembersLastFocusedIndexPath(_ value: Bool) -> Self {
        me.remembersLastFocusedIndexPath = value
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func selectionFollowsFocus(_ value: Bool) -> Self {
        me.selectionFollowsFocus = value
        return self
    }

    @available(iOS 15.0, *)
    @discardableResult
    public func allowsFocus(_ value: Bool) -> Self {
        me.allowsFocus = value
        return self
    }

    @available(iOS 15.0, *)
    @discardableResult
    public func allowsFocusDuringEditing(_ value: Bool) -> Self {
        me.allowsFocusDuringEditing = value
        return self
    }
}

/// Drag & Drop
extension DTBKitWrapper where Base: UITableView {
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dragInteractionEnabled(_ value: Bool) -> Self {
        me.dragInteractionEnabled = value
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func isSpringLoaded(_ value: Bool) -> Self {
        me.isSpringLoaded = value
        return self
    }
}

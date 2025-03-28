//
//  UICollectionView+XMKit.swift
//  XMKit
//
//  Created by HuChangChang on 2024/1/24.
//

import UIKit

extension Wrapper where Base: UICollectionView {
    
    /// Use ``String(describing: Cell.self)`` to cell identifier | 直接用类名作为重用标识
    ///
    /// More details in ``dtbkit_explain.md``
    @discardableResult
    public func registerCell<T: UICollectionViewCell>(_ cellClass: T) -> Self {
        me.register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
        return self
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier | 直接用类名作为重用标识
    ///
    /// More details in ``dtbkit_explain.md``
    @discardableResult
    public func registerHeader<T: UICollectionReusableView>(_ viewClass: T) -> Self {
        me.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self))
        return self
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier | 直接用类名作为重用标识
    ///
    /// More details in ``dtbkit_explain.md``
    @discardableResult
    public func registerFooter<T: UICollectionReusableView>(_ viewClass: T) -> Self {
        me.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: T.self))
        return self
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier | 直接用类名作为重用标识
    ///
    /// More details in ``dtbkit_explain.md``
    public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        if let cell = me.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T {
            return cell
        }
        assert(false)
        return T()
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier | 直接用类名作为重用标识
    ///
    /// More details in ``dtbkit_explain.md``
    public func dequeueReusableSupplementaryViewHeader<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        if let header = me.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T {
            return header
        }
        assert(false)
        return T()
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier | 直接用类名作为重用标识
    ///
    /// More details in ``dtbkit_explain.md``
    public func dequeueReusableSupplementaryViewFooter<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        if let footer = me.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T {
            return footer
        }
        assert(false)
        return T()
    }
}

//
//  UICollectionView+XMKit.swift
//  XMKit
//
//  Created by HuChangChang on 2024/1/24.
//

import Foundation

extension DTBKitWrapper where Base: UICollectionView {
    
    /// Use ``String(describing: Cell.self)`` to cell identifier.
    ///
    /// 直接用类名作为重用标识。
    @discardableResult
    public func registerCell<T: UICollectionViewCell>(_ cellClass: T) -> Self {
        me.register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
        return self
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier.
    ///
    /// 直接用类名作为重用标识。
    @discardableResult
    public func registerHeader<T: UICollectionReusableView>(_ viewClass: T) -> Self {
        me.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self))
        return self
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier.
    ///
    /// 直接用类名作为重用标识。
    @discardableResult
    public func registerFooter<T: UICollectionReusableView>(_ viewClass: T) -> Self {
        me.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: T.self))
        return self
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier, will trigger assert when got nil.
    ///
    /// 直接用类名作为重用标识，并避免返回可选值。
    public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        if let cell = me.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T {
            return cell
        }
        assert(false)
        return T()
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier, will trigger assert when got nil.
    ///
    /// 直接用类名作为重用标识，并避免返回可选值。
    public func dequeueReusableSupplementaryViewHeader<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        if let header = me.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T {
            return header
        }
        assert(false)
        return T()
    }
    
    /// Use ``String(describing: Cell.self)`` to cell identifier, will trigger assert when got nil.
    ///
    /// 直接用类名作为重用标识，并避免返回可选值。
    public func dequeueReusableSupplementaryViewFooter<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        if let footer = me.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T {
            return footer
        }
        assert(false)
        return T()
    }
}

//
//  UICollectionView+DTBKit.swift
//  DTBKit
//
//  Created by HuChangChang on 2024/1/24.
//

import UIKit

extension DTB.Wrapper where Base: UICollectionView {

    @discardableResult
    public func registerCell<T: UICollectionViewCell>(_ cellClass: T.Type) -> Self {
        me.register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
        return self
    }

    @discardableResult
    public func registerHeader<T: UICollectionReusableView>(_ viewClass: T.Type) -> Self {
        me.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self))
        return self
    }

    @discardableResult
    public func registerFooter<T: UICollectionReusableView>(_ viewClass: T.Type) -> Self {
        me.register(T.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: T.self))
        return self
    }

    public func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T? {
        return me.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
    }

    public func dequeueReusableCellEnsured<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        if let cell = me.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T {
            return cell
        }
        DTB.console.assert()
        return T()
    }

    public func dequeueReusableSupplementaryViewHeader<T: UICollectionReusableView>(for indexPath: IndexPath) -> T? {
        return me.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
    }

    public func dequeueReusableSupplementaryViewHeaderEnsured<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        if let header = me.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T {
            return header
        }
        DTB.console.assert()
        return T()
    }

    public func dequeueReusableSupplementaryViewFooter<T: UICollectionReusableView>(for indexPath: IndexPath) -> T? {
        return me.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
    }

    public func dequeueReusableSupplementaryViewFooterEnsured<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
        if let footer = me.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: T.self), for: indexPath) as? T {
            return footer
        }
        DTB.console.assert()
        return T()
    }
}

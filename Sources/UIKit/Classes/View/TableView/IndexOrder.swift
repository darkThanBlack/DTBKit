//
//  IndexOrder.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/25
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

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
    public func indexOrder(_ indexPath: IndexPath) -> DTB.IndexOrder {
        let count = me.numberOfRows(inSection: indexPath.section)
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

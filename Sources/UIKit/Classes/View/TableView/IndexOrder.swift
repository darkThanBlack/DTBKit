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
    
    /// index 在 list 里的位置
    public enum IndexOrder {
        /// 只有 1 个
        case onlyOne
        /// 是列表里的第 1 个
        case isFirst
        /// 是普通元素
        case isMiddle
        /// 是列表里的最后 1 个
        case isLast
        
        public init(index: Int, totalCount: Int) {
            if totalCount < 2 {
                self = .onlyOne
            }
            if index == 0 {
                self = .isFirst
            }
            if index == totalCount - 1 {
                self = .isLast
            }
            self = .isMiddle
        }
        
        public init(indexPath: IndexPath, tableView: UITableView) {
            self.init(index: indexPath.row, totalCount: tableView.numberOfRows(inSection: indexPath.section))
        }
        
        public var verticalCorners: UIRectCorner {
            switch self {
            case .onlyOne:   return [.allCorners]
            case .isFirst:   return [.topLeft, .topRight]
            case .isMiddle:  return []
            case .isLast:    return [.bottomLeft, .bottomRight]
            }
        }
    }
}

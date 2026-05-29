//
//  SectionModel.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/29
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    /// For simple table list | 提供了一个简单的 UITableView/UICollectionView 数据模型
    public final class SectionModel {
        
        public var header: CellModel?
        
        public var footer: CellModel?
        
        public var cells: [CellModel] = []
        
        public var extra: Any? = nil
        
        public init(
            header: CellModel? = nil,
            footer: CellModel? = nil,
            cells: [CellModel],
            extra: Any? = nil
        ) {
            self.header = header
            self.footer = footer
            self.cells = cells
            self.extra = extra
        }
    }
}

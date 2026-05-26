//
//  SimpleSectionModel.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/26
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// For simple table list | 提供了一个简单的 UITableView/UICollectionView 数据模型
    public final class SimpleSectionModel {
        
        public var header: SimpleModel?
        
        public var footer: SimpleModel?
        
        public var cells: [SimpleModel] = []
        
        public var extra: [String: Any]? = nil
        
        public init(
            cells: [SimpleModel],
            header: SimpleModel? = nil,
            footer: SimpleModel? = nil,
            extra: [String : Any]? = nil
        ) {
            self.cells = cells
            self.header = header
            self.footer = footer
            self.extra = extra
        }
    }
    
}

//
//  DTBKit.swift
//  DTBKit
//
//  Created by moonShadow on 2023/6/28
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

extension DTB {
    
    /// For simple business data | 提供了一些常见字段用于简单业务处理
    public final class SimpleModel {
        
        public var primaryKey: String?
        
        public var icon: UIImage?
        
        public var title: String?
        
        public var detail: String?
        
        public var desc: String?
        
        public var tag: String?
        
        public var titleAttr: NSAttributedString?
        
        public var detailAttr: NSAttributedString?
        
        public var jumpable: Bool?
        
        public var selectable: Bool?
        
        public var isSelected: Bool?
        
        public var editable: Bool?
        
        public var extra: [String: Any]?
        
        public init(
            primaryKey: String? = nil,
            icon: UIImage? = nil,
            title: String? = nil,
            detail: String? = nil,
            desc: String? = nil,
            tag: String? = nil,
            titleAttr: NSAttributedString? = nil,
            detailAttr: NSAttributedString? = nil,
            jumpable: Bool? = nil,
            selectable: Bool? = nil,
            isSelected: Bool? = nil,
            editable: Bool? = nil,
            extra: [String : Any]? = nil
        ) {
            self.primaryKey = primaryKey
            self.icon = icon
            self.title = title
            self.detail = detail
            self.desc = desc
            self.tag = tag
            self.titleAttr = titleAttr
            self.detailAttr = detailAttr
            self.jumpable = jumpable
            self.selectable = selectable
            self.isSelected = isSelected
            self.editable = editable
            self.extra = extra
        }
    }
    
    /// For simple table list | 提供了一个简单的 UITableView/UICollectionView 数据模型
    public final class SimpleSectionModel {
        
        public var header: SimpleModel?
        
        public var footer: SimpleModel?

        public var cells: [SimpleModel] = []
        
        public init(header: SimpleModel? = nil, footer: SimpleModel? = nil, cells: [SimpleModel]) {
            self.header = header
            self.footer = footer
            self.cells = cells
        }
    }
    
}

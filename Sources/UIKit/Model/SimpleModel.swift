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

extension DTB.SimpleModel: DTB.TDIArrowData {}

extension DTB.SimpleModel: DTB.ITDIArrowData {}

extension DTB {
    
    /// For simple business data | 提供了一些常见字段用于简单业务处理
    public final class SimpleModel {
        
        public var primaryKey: String?
        
        public var leftImage: ImageData?
        
        public var title: String?
        
        public var detail: String?
        
        public var desc: String?
        
        public var tags: [String]?
        
        public var titleAttr: NSAttributedString?
        
        public var detailAttr: NSAttributedString?
        
        public var showArrow: Bool?
        
        public var jumpable: Bool?
        
        public var selectable: Bool?
        
        public var isSelected: Bool?
        
        public var editable: Bool?
        
        public var extra: [String: Any]?
        
        public init(
            primaryKey: String? = nil,
            leftImage: ImageData? = nil,
            title: String? = nil,
            detail: String? = nil,
            desc: String? = nil,
            tags: [String]? = nil,
            titleAttr: NSAttributedString? = nil,
            detailAttr: NSAttributedString? = nil,
            showArrow: Bool? = nil,
            jumpable: Bool? = nil,
            selectable: Bool? = nil,
            isSelected: Bool? = nil,
            editable: Bool? = nil,
            extra: [String : Any]? = nil
        ) {
            self.primaryKey = primaryKey
            self.leftImage = leftImage
            self.title = title
            self.detail = detail
            self.desc = desc
            self.tags = tags
            self.titleAttr = titleAttr
            self.detailAttr = detailAttr
            self.showArrow = showArrow
            self.jumpable = jumpable
            self.selectable = selectable
            self.isSelected = isSelected
            self.editable = editable
            self.extra = extra
        }
    }
    
}

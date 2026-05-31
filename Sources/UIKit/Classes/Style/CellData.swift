//
//  CellData.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/29
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB.CellData: DTB.TDIArrowData {}

extension DTB.CellData: DTB.TDISelectData {}

extension DTB.CellData: DTB.ITDIArrowData {}

extension DTB {
    
    public final class CellData {
        
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


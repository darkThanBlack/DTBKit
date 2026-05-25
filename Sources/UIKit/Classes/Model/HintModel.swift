//
//  HintsCell.swift
//
//  Created by moonShadow on 2024/2/3
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import UIKit

extension DTB {
    
    /// 简单展示 cell
    public struct HintModel: HintData {
        
        public var primaryKey: String?
        
        public var title: String?
        
        public var detail: String?
        
        public var showArrow: Bool
        
        public init(primaryKey: String? = nil, title: String? = nil, detail: String? = nil, showArrow: Bool = true) {
            self.primaryKey = primaryKey
            self.title = title
            self.detail = detail
            self.showArrow = showArrow
        }
    }
    
}

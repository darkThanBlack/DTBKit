//
//  MineSimpleItemModel.swift
//  tarot
//
//  Created by moonShadow on 2025/11/19
//  Copyright © 2025 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

class MineSimpleItemModel: MineSimpleItemDelegate {
    
    var key: String?
    
    var title: String?
    
    var detail: String?
    
    var showRightArrow: Bool?
    
    var isSelected: Bool?
    
    init(key: String?, title: String?, detail: String? = nil, showRightArrow: Bool? = nil, isSelected: Bool? = nil) {
        self.key = key
        self.title = title
        self.detail = detail
        self.showRightArrow = showRightArrow
    }
}

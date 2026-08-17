//
//  SegmentItem.swift
//  Ring
//
//  Created by moonShadow on 2026/6/18
//  Copyright © 2026 moon. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    @objc(DTBSegmentItem)
    open class SegmentItem: UIView {
        
        open var isSelected: Bool = false {
            didSet {
                reloadAppearance()
            }
        }
        
        /// 子类重写以响应 isSelected 变化
        open func reloadAppearance() {
            DTB.console.error("fatal error: 错误的方法调用，或子类没有正确实现")
        }
    }
}

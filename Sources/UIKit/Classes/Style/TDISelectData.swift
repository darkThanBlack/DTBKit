//
//  TDISelectData.swift
//  DTBKit
//
//  Created by moonShadow on 2026/5/31
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import UIKit

extension DTB {
    
    /// 简单展示
    public protocol TDISelectData {
        
        /// 左侧标题
        var title: String? { get }
        
        /// 左侧详情
        var detail: String? { get }
        
        ///
        var isSelected: Bool? { get }
    }
}

extension DTB.TDIView {
    
    public static func select() -> DTB.TDIView {
        let view = DTB.TDIView()
        view.rightImageView.dtb
            .tintColor(.dtb.create("theme"))
            .image(.dtb.local("checkmark.circle.fill"))
        return view
    }
    
    public func updateSelectData(_ data: DTB.TDISelectData?) {
        titleLabel.dtb
            .text(data?.title)
            .hiddenWithEmptyText()
        
        detailLabel.dtb
            .text(data?.detail)
            .hiddenWithEmptyText()
        
        rightImageView.dtb
            .isHidden((data?.isSelected == true) ? false : true)
    }
}

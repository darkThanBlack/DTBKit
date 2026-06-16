//
//  TDIArrowData.swift
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
    public protocol TDIArrowData {
        
        /// 左侧标题
        var title: String? { get }
        
        /// 左侧详情
        var detail: String? { get }
        
        /// 右侧箭头
        var showArrow: Bool? { get }
    }
}

extension DTB.TDIView {
    
    public static func arrow() -> DTB.TDIView {
        let view = DTB.TDIView()
        view.rightImageView.dtb
            .tintColor(.dtb.create("arrow"))
            .image(.dtb.local("chevron.right"))
        return view
    }
    
    public func updateArrowData(_ data: DTB.TDIArrowData?) {
        titleLabel.dtb
            .text(data?.title)
            .hiddenWithEmptyText()
        
        detailLabel.dtb
            .text(data?.detail)
            .hiddenWithEmptyText()
        
        rightImageView.dtb
            .isHidden((data?.showArrow == true) ? false : true)
    }
}

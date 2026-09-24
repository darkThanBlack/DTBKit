//
//  BaseView.swift
//  DTBKit
//
//  Created by moonShadow on 2025/11/22
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import UIKit

extension DTB {
    
    ///
    @objc(DTBBaseView)
    open class BaseView: UIView, DTB.LayoutEventLazyFireable {
        
        public var lazyLayoutEventsPool_: [DTB.LayoutEventLazyFireTiming : [(UIView) -> ()]] = [:]
        
        open override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            lazyLayoutsWhenDidMoveToSuperview_()
        }
        
        open override func layoutSubviews() {
            super.layoutSubviews()
            
            // 过滤掉系统的无效触发
            guard bounds.isEmpty == false else { return }

            lazyLayoutsWhenLayoutSubviews_()
        }
        
    }
    
}
